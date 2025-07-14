class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "2ed43e82505f462bcd8851579b55a5f37089825e1b717b3c928b2bfdbf5eecd0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2e9793a1957841ab2743fd3f4749e94ed11b28388063e01f233ce35788574cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d591774836a4ddb1bfa8f8843250dadc2c13c4359ae528d4359e237e8981281"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "261c373f5c07bb38f711c541c8e1a39d797b2b7d818ceda3f98421cb95a11c12"
    sha256 cellar: :any_skip_relocation, sonoma:        "7021cac89225b16ed3f045a3a1018e0413f0409efc826badb6595b88f3762a5c"
    sha256 cellar: :any_skip_relocation, ventura:       "8a4833e729b8910ff0ecd4d7b5554228b9d2e6e0fdb6539a87b4b1db69a05431"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c89993e243dd292b078c9aee2523ea15f424c84333f4e9056e33753db97dedd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69841b5b77b0c3cf4b7ed6f206aee679d0e5581499a447be0e1de2af79fde443"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"bob", "complete")
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
