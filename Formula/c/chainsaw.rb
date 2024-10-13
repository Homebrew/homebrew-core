class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "d43625f154c40a61e0253a300b1623c3e19c90ea0d6036d8190d3d854492962a"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e7165bfdec06fd79a8fb58bfb7089b269eedba95b8cfe64dc5ceb0099da8bd3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f955ab08021e1bf3d8f9be4962fcbfaa21ad3f52eebff1d57bd03d8e0aebb150"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ed9867258ffcd9afc6f510f9db0e05209ec162c284e62b6dd84f7df1e4e1ad9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff5ae553ce404df31971c7a6b1b88574d711be6bb1365a78e52267f903b12fae"
    sha256 cellar: :any_skip_relocation, sonoma:         "f080ea6fd02cfd70608831f8c51577ed84c14d3f74bd7ba985adedf5c0e5e6fa"
    sha256 cellar: :any_skip_relocation, ventura:        "a8b686f9f2f2826b15ba6b0ccbbb5bf6121723ad6c7207775ca5459bcb434021"
    sha256 cellar: :any_skip_relocation, monterey:       "b7eab7f09afd4ec1c50f81285b787bdd9291808d4e2056c17ca09a22e984b897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83609bd624a4b434beca7ddad9f79a44a53d43a7400f467174b0885a26a4526e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "chainsaw" do
      output = shell_output("#{bin}/chainsaw lint --kind chainsaw . 2>&1")
      assert_match "Validated 0 detection rules out of 0", output

      output = shell_output("#{bin}/chainsaw dump --json . 2>&1", 1)
      assert_match "Dumping the contents of forensic artefact", output
    end

    assert_match version.to_s, shell_output("#{bin}/chainsaw --version")
  end
end
