class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://github.com/MordechaiHadad/bob/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "6a50c8728d2a7706a2fd3d0395f32447bb5d83935ccec327de0cde65055ab1c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ecfc6a3f4af3b6004ac7977319603e8bae46ae35fad91f68c928929da3030d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c79c02468ba42bf12bf517d6ae776a8ed4eabf9d6f26b7e0113e60531eff0d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "181702e2348f17289c8da5d19a3521866031fdb3079e8c1b1c5aa49752831ff1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a7f8c3f2bbf33f2b6036e6c7921232a01e43c6a18bcc723d2e0f5b4272bc53f"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeca7c1b985cf8a6e9e93e8d1e1fba2dd460b6915a04d5a899b6afdd6abaef60"
    sha256 cellar: :any_skip_relocation, ventura:       "ef196cd394d537ea75908af21b40a34bd2aaa4c8f0725010086daf8837a4a38c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59c48ffedac8a1000d1a2ff5753978ffa0e50a95026d3b2487bd507a48b9734d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1633b44210e1390498ae622522639862000c5a37a39abe0fbca077347e7ce9dd"
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
