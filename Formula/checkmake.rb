class Checkmake < Formula
  desc "Linter/analyzer for Makefiles"
  homepage "https://github.com/mrtazz/checkmake"
  url "https://github.com/mrtazz/checkmake/archive/refs/tags/0.2.1.tar.gz"
  sha256 "6e0d5237bc1de2a42ba1cf1a5c1da7d783bd9da06755e0c7faba6c3ba77ab1ee"
  license "MIT"
  head "https://github.com/mrtazz/checkmake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b44ebba9cd231360d1ce26bf267d1de798ba46749de675754e53d45db4c32da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24ce2c8ae0ac84bd82f2d9fcca62b79e2fe189ebbf41b502292f620e8d02d75c"
    sha256 cellar: :any_skip_relocation, monterey:       "62cfef18de480939e07625149342472987f67bd90b1178af336ba0b4fc0bcb68"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a74120f70f175c06024f27e623d17f6a832add7396b1d938d53260cf2c53453"
    sha256 cellar: :any_skip_relocation, catalina:       "31a3acccf4806de261ea299a45e07e733d376d5adc77bc8f04941d4c1cbda25f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6fa0c4144a7bae1f4dc990a13eaf4a0970ff7b84ea3afdb30ae6a3cfe90b491"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    ENV["BUILDER_NAME"] = "Homebrew"
    ENV["BUILDER_EMAIL"] = "homebrew@brew.sh"
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    sh = testpath/"Makefile"
    sh.write <<~EOS
      clean:
      \trm bar
      \trm foo

      foo: bar
      \ttouch foo

      bar:
      \ttouch bar

      all: foo

      test:
      \t@echo test

      .PHONY: clean test
    EOS
    assert_match "phonydeclared", shell_output("#{bin}/checkmake #{sh}", 2)
  end
end
