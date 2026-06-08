class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v4.1.7.tar.gz"
  sha256 "ad9c8b7ba04e3eb006d1d3646107abfcf5615ee588c1deb7969a9cfca6267f76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24380fb4df756e2c13586d049d76f6da879dbb606f3d7288e9c7911bbfc1570a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62fbf4131d2f43b1e5771358c5b46272f1c7df3be3d0b9fda8931ff5d81592e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4f6717e783186338cf38ed614e717e648f9290aa51cb319e565ed79d448e41d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b549c88829bd38e798d9882380eeb8789e4319fc7561d6d4fe2bc87f360d19c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a5f3d29d468128ffb037aa8553353bf007ef0d6d095ffc0a33031d050c3f9f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0cd8c2bdb705538d162ca02c2ffb48c87cf19ff85953156e755a4cbfe50f062"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"bob", "complete")
    # For powershell, `power-shell` is required
    (pwsh_completion/"_bob.ps1").write Utils.safe_popen_read(bin/"bob", "complete", "power-shell")
  end

  test do
    config_file = testpath/"config.json"
    config_file.write <<~JSON
      {
        "downloads_location": "#{testpath}/.local/share/bob",
        "installation_location": "#{testpath}/.local/share/bob/nvim-bin"
      }
    JSON

    ENV["BOB_CONFIG"] = config_file
    mkdir_p testpath/".local/share/bob"
    mkdir_p testpath/".local/share/nvim-bin"

    neovim_version = "v0.11.0"
    system bin/"bob", "install", neovim_version
    assert_match neovim_version, shell_output("#{bin}/bob list")
    assert_path_exists testpath/".local/share/bob"/neovim_version

    # failed to run `bob erase` in linux CI
    # upstream bug report, https://github.com/MordechaiHadad/bob/issues/287
    system bin/"bob", "erase" unless OS.linux?
  end
end
