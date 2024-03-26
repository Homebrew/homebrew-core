class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "c8bbedae685520ad79aa3adb268db0cc79999e1a4f3c20b902100fe9cc3ea34c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "041a6862d2d8d9ddd5514cba14d782e1ad3edf5922d5b799b71f72bcd9e4247b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07c6efc868f91eeceed1f639da982d5b3f9c5562bf938c16e5a87367ebd4da76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54ba4a3099393bd7fa9268f82ea5759cd75f44e5e22f4e6197ba80d4c519748d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4e4c826c0fb9e475549fd54a93a9707c1dc36145b4c2affdfe921c894fbd709"
    sha256 cellar: :any_skip_relocation, ventura:        "af6239f1a4d0456d8dbbe086c24692864137ba1671759f39d9f9543ee0e26898"
    sha256 cellar: :any_skip_relocation, monterey:       "bcc0ba93ea2490360a24ca2cbffba95b25f4f275c79cc3ff02ce89e488916930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b8730ddf79801681449d82b19887b239442884a78cae94bd88fc575b5285be0"
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
