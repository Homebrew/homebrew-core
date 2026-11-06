class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://github.com/sass/dart-sass/archive/refs/tags/1.108.0.tar.gz"
  sha256 "0dfc78bf094ee144a4f40f91c693c67fec990bac366a28eb856a669074fbd4af"
  license "MIT"
  compatibility_version 1

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "7d605e27d0a6d2fa265fdea1e8b208410c689cf7a3db20aeeacf812f50000211"
    sha256 cellar: :any,                 arm64_tahoe:       "3832c0dca1f99b4fb371568b57f2fa96c8faf5eabf0e5d14321859b49669422b"
    sha256 cellar: :any,                 arm64_sequoia:     "4797c88ea336df376f776e4c3c7532baca0cd3e99a4af3cdeaea6d0b320bc4a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4eabc1175f52695ebad2c7dcf801b51af403101924788eef25012c418a6e59dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "da893d60246c1a4e1ec1a43ec825500c68f3418fc2b27882325876f421c7c74c"
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
