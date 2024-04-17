class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "ae5e00900e2813e795cbbcf5e39c76beb55c1ac5fda86f057550e90552a004c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01a9e88a7091b3fbb47f8fb869f043587dc08f81b4666006fd4e97ace425b296"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "629b411c3335b3a9039d53d5bf1be0ff8ca05ee13bb227dd056b132c38f70c1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63ee4be94d09c700a89961ffcf8ef5039a504d77b69a89ebc53d3a1ebbbda0fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "696df427087a9709f54425b0bc203f15cc3e95cd23ae0b1eb675378e79639f25"
    sha256 cellar: :any_skip_relocation, ventura:        "de2e51b1ce5cf18fb49afc5c0c0948203bfeff0356fc07c3fd704fe70c9bf17b"
    sha256 cellar: :any_skip_relocation, monterey:       "2db203ee198773a09b5960e4eff3a36f5dab3f7741825b628afac8d151a12891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e3fa510962656f0092a1127fc9b3c1ffb662cc54d595517a0e669d2317565e7"
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
