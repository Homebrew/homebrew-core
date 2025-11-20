class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v4.1.4.tar.gz"
  sha256 "8c235d68bc1f94199972753ed1a50475c4cd8e6729eb6b362ef442e21e08e107"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c1df6d3c524a6fb964a940cfaa0e27261949c70626ef9a916274e5ca8893545"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "551116855bf049e05a3c4af134824aab0027de3d0e37977ef6c90645ffba7b59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55238d697646caf9ebb529369632d58321fc7ca54878b6a7d06a6ae723655231"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5c35f5df459a2b9e5c2d63e327820d218b17e0154b0396726d844c4985379ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78bf3941c9343411246e565986881ee6769b12cf3bc182e086d59f14682c1f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6915c4fadbc935ddfc8bf3ca7ef7939885910941dae0c48fb29202332229831"
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
