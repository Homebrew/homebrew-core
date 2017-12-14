class Eureka < Formula
  desc "CLI tool to input and store your ideas without leaving the terminal"
  homepage "https://github.com/simeg/eureka"
  url "https://github.com/simeg/eureka/archive/v1.0.0.tar.gz"
  sha256 "19da7540b7232d25f8d180d58f4356534f7694eee5172eddc0e5bcf900e380c8"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/eureka"
  end

  test do
    system bin/"eureka", "--help"
  end
end
