class DartSass < Formula
  desc "Reference implementation of Sass, written in Dart"
  homepage "https://sass-lang.com/dart-sass"
  url "https://github.com/sass/dart-sass/archive/refs/tags/1.101.0.tar.gz"
  sha256 "2af48b186eb895f5e70a2fd29e001b0dcb98d51382dd95117ad1be68f600788f"
  license "MIT"

  # Some tags are used for sass-api/sass-parser
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd56e48f7b6b5f431eedb7748c243600561361306b4e01339c4bdfb318f11853"
    sha256 cellar: :any,                 arm64_sequoia: "c7110799ec47c0a41d5d0a167bb0899d5627781a649778648f25a9549973e1e8"
    sha256 cellar: :any,                 arm64_sonoma:  "ed046bf044f14c8a9e2a504e2cec9100b895a9a9aa7d8cdf3a394c958e79aaeb"
    sha256 cellar: :any,                 sonoma:        "cff3394ae49a55ff71c01faef336a9317b5b125abb8a9161adfe83b75515d043"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "455a3e31b77d0f7d5ee22deb7a29c52787700cbe78f461ee91a57fee805b9a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd7d12bbcc0fae52d46a75e50426fa9caff7060b7af14c453fd3de7b244b6eeb"
  end

  depends_on "buf" => :build
  depends_on "dart-sdk" => :build
  depends_on "dartaotruntime"

  resource "language" do
    url "https://github.com/sass/sass/archive/refs/tags/embedded-protocol-3.2.0.tar.gz"
    sha256 "4e1f81684bc1666f03e52ddc790d0c2c22d99a5313fa2efe1dde4a5b5733c186"

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
