class Eureka < Formula
  desc "CLI tool to input and store your ideas without leaving the terminal"
  homepage "https://github.com/simeg/eureka"
  url "https://github.com/simeg/eureka/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "b9eb7d49b51341976d72280a7edb8857358ef8ec3715cf4f26da12420622c85b"
  license "MIT"
  head "https://github.com/simeg/eureka.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "fcca826a0c490097e7e3243bb2568e8d9c9609221086a8bcc29d908af53aed4c"
    sha256 cellar: :any, arm64_tahoe:       "95e8d555017dd25c4ac2b99589e1b476a2c7fdd9e8a6a345795a007e7fb23ae3"
    sha256 cellar: :any, arm64_sequoia:     "58a6ab0a632ebc3ab366b1d5f25919a3b56cca97a8b656156ed0e24891013f14"
    sha256 cellar: :any, arm64_sonoma:      "fb79daf2022ba0b83542df3c81bb4b410ec09b795e706e5349668c0a1b0e2fb0"
    sha256 cellar: :any, arm64_linux:       "f44d91be16ef8cbe07929da00ce956fe3d54ab59c0adee70c43c3fc245581e9d"
    sha256 cellar: :any, x86_64_linux:      "c57fe75ad2bfacb2f72567ac2e41d680b7190caaeaf937fcb23a67497ee486ca"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "eureka [OPTIONS]", shell_output("#{bin}/eureka --help 2>&1")

    (testpath/".eureka/repo_path").write <<~EOS
      homebrew
    EOS

    assert_match "ERROR eureka > No such file or directory", pipe_output("#{bin}/eureka --view 2>&1")
  end
end
