class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://github.com/sass/dart-sass/archive/refs/tags/1.108.1.tar.gz"
  sha256 "a00bf6aeb0fc22183140728b72fa1f8603ff6e9e314e6fb816c3dbf5ddd5d614"
  license "MIT"
  compatibility_version 1

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "439ccb5b1dfd4dbce92f7f41ffe9ca4e9e264359b93afe6427e52d27e4ee00a6"
    sha256 cellar: :any,                 arm64_tahoe:       "27f9367d9972caa2fd72359a45189ab2e7d878424e765dfb39b3ebf26280eb39"
    sha256 cellar: :any,                 arm64_sequoia:     "5ef4f85d64c0fea9c22134e0a71904f88fcbfc5389c01491881971db7a4ae8e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1dd7dfb65603b02e14899dc020c60d9b57da14020b926c2c275732bc502b9d65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6a2dce9572f68efaad2579c74f588bccc3a4c2fe56f4e1a857e51c983813f66e"
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
