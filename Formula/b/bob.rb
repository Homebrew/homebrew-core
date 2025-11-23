class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v4.1.5.tar.gz"
  sha256 "1d87878c81d5084eabdf2f11540fb3eb2b900d734217a9cd1c45386cf40ade0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e5986560f5ca568868fc264c5d0c4d79a9aa0c545a20e300f88037e5483ddf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "102b9975a80719364ca6cf81aa7583c719aa6c842c0d6e321d9f734c1e629c11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7ab5713806ba872354a3de1eada32ddfec7dfc91f0a4504dd7afa2dfdce667b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbe02540faf0e806373c1d8a514992523250f0f50107c25010b78b098e945603"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae43b3e71ff29608835717b547d8d910b73c992217e23a40129c3635249892df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b13219dfce3166ed045de9f21bdf923a22445eab0c7c5915b67ab19d11046e98"
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
