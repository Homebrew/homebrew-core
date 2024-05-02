class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "06b5a7e416b9b10d85fa6d04ecdd743138cf7e81c1180d2b25c301bc0bd1561a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be0e3c881599e69fade8b75849036026bbb4b349e1e6751b54a816501a9a7cac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fd30f4f2af2c3f54bdca2acfe0c65931d1725c9045d0258eb5e5371178f0314"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "568467fe9c244bd85b612f0978b1c143de19bd0118d16c606160b13b11576e59"
    sha256 cellar: :any_skip_relocation, sonoma:         "efa6fc0250f377259070f495d5ce2a485693020f719ce7256e3c14f625879c33"
    sha256 cellar: :any_skip_relocation, ventura:        "d98e54be7326c027dd9159e0be4ab5689be3b2d08e1d37e2076304c97edd2fac"
    sha256 cellar: :any_skip_relocation, monterey:       "0ba9fa5d67e9345605e9105eeef37756788f38d41a4b9a0308270c2b2ac4030c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3d3abcb64757274a23a0a1883663aa96bd5722875796e23522625a522840fa4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"bob", "complete")
  end

  test do
    config_file = testpath/"config.json"
    config_file.write <<~EOS
      {
        "downloads_location": "#{testpath}/.local/share/bob",
        "installation_location": "#{testpath}/.local/share/bob/nvim-bin"
      }
    EOS
    ENV["BOB_CONFIG"] = config_file
    mkdir_p "#{testpath}/.local/share/bob"
    mkdir_p "#{testpath}/.local/share/nvim-bin"

    system "#{bin}/bob", "install", "v0.9.0"
    assert_match "v0.9.0", shell_output("#{bin}/bob list")
    assert_predicate testpath/".local/share/bob/v0.9.0", :exist?
    system "#{bin}/bob", "erase"
  end
end
