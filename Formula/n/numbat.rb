class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://github.com/sharkdp/numbat"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "9543f449e758b2db6d1299b4eee88dbeac1ba57a427580c7f45d3ee613b089a0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9035de1dee779276a6e0de27d493f4af88565f387e9077358cb519de7d026bbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9ae0d1c9a1f8931a6d83781e68d9bdabfc3c12338b095ab8063f38f2322fa9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d438869a9573110c5e97491b63759eeb3ccf697c9c5502d6da8b8247f0aa4d42"
    sha256 cellar: :any_skip_relocation, sonoma:         "b97165dee97ade2e4dab2e66ad3f0bdcc130ffabfb999f303bb2344a4fb5a391"
    sha256 cellar: :any_skip_relocation, ventura:        "0f050ac7bd8e6e940fa6b3c90284f45c8c6d3ba616a50ae16ea02890c644c74f"
    sha256 cellar: :any_skip_relocation, monterey:       "73fd7bcced5d0f4069c6e529e49e9c55fdf5f0c9150dce606800c8c6444766b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c47ed0161f2225e5403d8e0e1d74081dbe7334b539dd226d87d843955e89488"
  end

  depends_on "rust" => :build

  def install
    ENV["NUMBAT_SYSTEM_MODULE_PATH"] = "#{pkgshare}/modules"
    system "cargo", "install", *std_cargo_args(path: "numbat-cli")

    pkgshare.install "numbat/modules"
  end

  test do
    (testpath/"test.nbt").write <<~EOS
      print("pi = {pi}")
    EOS

    output = shell_output("#{bin}/numbat test.nbt")

    assert_equal "pi = 3.14159", output.chomp
  end
end
