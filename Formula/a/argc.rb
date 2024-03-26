class Argc < Formula
  desc "Easily create and use cli based on bash script"
  homepage "https://github.com/sigoden/argc"
  url "https://github.com/sigoden/argc/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "83e6bbc7a0f90189db79dd30c6e32040078e1eced8635f860e15e512675e0802"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd19510fc580e6c827398c6849cf3a35a47df67277626b89a79bb4820941bab5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c39284ec523f9c48ca30edaf4ea2f61406dd4a6b4058bf2ac5e36601f7ce917f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a43f99c4ecdaf2e423c09890134505d2c328e688654df58f6e11587ee9c744b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b793d01e9ea7c9ffe1a83cb32ea912b51e1d7e586fabe32afcca8d0b3368651"
    sha256 cellar: :any_skip_relocation, ventura:        "83360e6c67b9c062b92affa8c315c457d256c8f631f0f0be6101d9ac004ebd05"
    sha256 cellar: :any_skip_relocation, monterey:       "b0c7f9d08f346243a3f81f2a62e67464d69d2d59b0c29b1cb3f024fbc562d53a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46c7d1712f2de58b5bbd51a0b836a56b6d61d95076c9414766603622738ccc09"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"argc", "--argc-completions")
  end

  test do
    system bin/"argc", "--argc-create", "build"
    assert_predicate testpath/"Argcfile.sh", :exist?
    assert_match "build", shell_output("#{bin}/argc build")
  end
end
