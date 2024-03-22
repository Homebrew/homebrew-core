class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "e98a00898c2573649d242d87b21af6cdeb5fd1c0fb5a9df53d9c18fc3c1c5008"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9c24e44a89f8cbbf3338fed2b59c09f4fde6aa241d6e79578d48e43ca2bb6f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a88b5d3c8ef0338a18953abb694af42663b9cdf5757e88de6489e4a5b74ae856"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6e374ec537443bd38685b2b7ccf5cd12783195e3953cf9e03831e7aec36638e"
    sha256 cellar: :any_skip_relocation, sonoma:         "13aab608e7aebc2bcf8d12c06c117280c9f62dc398e97a87f712bac6c08534c2"
    sha256 cellar: :any_skip_relocation, ventura:        "7e4e68c9765191543d74bee3ef31e0a936bc3cdba6d1a833661aba8e907f1b0f"
    sha256 cellar: :any_skip_relocation, monterey:       "dceeda710f5a7695b4610a46915fc9f31cc57a4a676af9db3eec6f33adf85789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45b5e4f198e4ac10edccb4a448d483b133d88dd5217926fdf3ea81eb4b98bfa7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end
