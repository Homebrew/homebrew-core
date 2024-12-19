class Melody < Formula
  desc "Language that compiles to regular expressions"
  homepage "https://yoav-lavi.github.io/melody/book"
  url "https://github.com/yoav-lavi/melody/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "b0dd1b0ecc1af97f09f98a9a741e0dddbf92380c9980140140ff1b4262b9a44a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9357930b4337a242439d8dad0bb624e77df223b85ca2feed819148ec193879d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69ec1b43828c1cddb1caea9c98c7d358d72f2b55dadd4ff1b9b6b609468af550"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f06eff1e2940053069a578f58f0dab013d23bf3734869c74b7943ef00e3c271"
    sha256 cellar: :any_skip_relocation, sonoma:        "232c51f62048c860a4b72b4dcfad31bfa1dd5933c63888cdf54d185e32640d0e"
    sha256 cellar: :any_skip_relocation, ventura:       "49ce44732ac20a95f265b901e3c6489e6330e7cfb30fc17c6b5eaf164272cc90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "551acffbd70fde043c5a83f3c7735580bb55686934ee9b79f90792a58d346303"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/melody_cli")

    generate_completions_from_executable(bin/"melody", "--generate-completions")
  end

  test do
    mdy = "regex.mdy"
    File.write mdy, '"#"; some of <word>;'
    assert_match "#\\w+", shell_output("#{bin}/melody --no-color #{mdy}")
  end
end
