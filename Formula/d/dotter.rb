class Dotter < Formula
  desc "Dotfile manager and templater written in rust"
  homepage "https://github.com/SuperCuber/dotter"
  url "https://github.com/SuperCuber/dotter/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "a62f2d55e48e5e9a84417960e8bdf0f2a9c3ce730dfd759e0f927055feb12e35"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5307fb4e60f7cb831ed7f8089534b4b7cd84b72c96e0e6099161ef39c28a9ea6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "185964ae1b8a33314762d1dff177b8d9eee3d517ac1ecbd6593e37fe92370c76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d946b97a58101cfc7e0050b7c820b6a7d3dd4662ed415a3363eb8b78cc0e27d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4af36f25c81f8ce899186039e473be1965bb8e22cfc539ef86d8599b330c95d"
    sha256 cellar: :any_skip_relocation, ventura:        "3a7bb2148d065ea6496c47ada4870bb7bf5382c6545cc28cdd574e50465735cf"
    sha256 cellar: :any_skip_relocation, monterey:       "dbfd42d7fb7353665f59561a6a19897cd0e27867e2298da15b45d5af5c19daaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44c4b1e3a7c37e55b65364fd3b965d31805019e695b940b89dcabf41076758cf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"dotter", "gen-completions", "-s")
  end

  test do
    (testpath/"xxx.conf").write("12345678")
    (testpath/".dotter/local.toml").write <<~EOS
      packages = ["xxx"]
    EOS
    (testpath/".dotter/global.toml").write <<~EOS
      [xxx.files]
      "xxx.conf" = "yyy.conf"
    EOS

    system bin/"dotter", "deploy"
    assert_match "12345678", File.read("yyy.conf")
  end
end
