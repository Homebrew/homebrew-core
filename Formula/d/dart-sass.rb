class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://github.com/sass/dart-sass/archive/refs/tags/1.108.2.tar.gz"
  sha256 "573b7d17d5369b7442534e158971c3cc1c439a19c4932b672a25b5c9d424a4ba"
  license "MIT"
  revision 1
  compatibility_version 1

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "f4c95b0edb572dd3ca7ee1ca07ea6b6df522fdd59069fa7dcfcc4dc002a4a75e"
    sha256 cellar: :any,                 arm64_tahoe:       "59e4d7a813f64820ce7caef61e062619e2ddab1328cd99815ac9a04d7e7c8ae1"
    sha256 cellar: :any,                 arm64_sequoia:     "8c8701cbe1277f13be9d1e90bf1cffbf2161809b4a7fa1333be8b670ca5872e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8baf5d3be7b015e29aed1d5eeac158689ce2ec24e1cc9aee67df0b5faa45bc73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5d31f274cc39c408bab4e404be2e5e32e9b8228bb385a943d48454927d24d125"
  end

  depends_on "buf" => :build
  depends_on "dart-sdk" => :build
  depends_on "dartaotruntime"

  # 1.107.0 needs `fatal_deprecation_except` from sass/sass main, which is not
  # in a tagged embedded protocol release yet (EMBEDDED_PROTOCOL_VERSION is still 3.3.0)
  resource "language" do
    url "https://github.com/sass/sass/archive/53e8d7548be7dc56b13e6914a82eedd69f0bd719.tar.gz"
    version "3.3.0"
    sha256 "f639f6ff603d89bd190bdf215b5caf4d11a29680db9f8c810782c888f36b5de8"

    livecheck do
      url :url
      regex(/embedded-protocol[._-]v?(\d+(?:\.\d+)+)/i)
    end
  end

  def install
    ENV["PUB_ENVIRONMENT"] = "homebrew:sass"
    ENV["DART_SUPPRESS_ANALYTICS"] = "true"

    (buildpath/"build/language").install resource("language")

    system "dart", "pub", "get"
    with_env(UPDATE_SASS_PROTOCOL: "false") do
      system "dart", "run", "grinder", "protobuf"
    end

    args = %W[
      -Dversion=#{version}
      -Ddart-version=#{Formula["dart-sdk"].version}
      -Dcompiler-version=#{version}
      -Dprotocol-version=#{resource("language").version}
    ]
    system "dart", "compile", "aot-snapshot", "--output", "sass.aot", *args, "bin/sass.dart"
    libexec.install "sass.aot"

    (bin/"sass").write <<~BASH
      #!/bin/bash
      exec "#{formula_opt_bin("dartaotruntime")}/dartaotruntime" "#{libexec}/sass.aot" "$@"
    BASH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sass --version")

    (testpath/"test.scss").write(".class {property: 1 + 1}")
    assert_match "property: 2;", shell_output("#{bin}/sass test.scss 2>&1")

    (testpath/"input.scss").write <<~SCSS
      div {
        img {
          border: 0px;
        }
      }
    SCSS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style compressed input.scss").strip
  end
end
