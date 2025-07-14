class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "57528df45381d5e009f2e50a602f2ef80bb54904a03b91c5ba72d73c820c83bb"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "983d1b65b8b4b5e7653662dc24df7b36a1d611878f5c63b464b0b9729b1a902d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "983d1b65b8b4b5e7653662dc24df7b36a1d611878f5c63b464b0b9729b1a902d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "983d1b65b8b4b5e7653662dc24df7b36a1d611878f5c63b464b0b9729b1a902d"
    sha256 cellar: :any_skip_relocation, sonoma:        "07df8f39824cc43a2709c6e47fc6e0d48ac40900ecb7b4ca16b9adab800d786f"
    sha256 cellar: :any_skip_relocation, ventura:       "07df8f39824cc43a2709c6e47fc6e0d48ac40900ecb7b4ca16b9adab800d786f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fef5bd02e8033df8dc3dc13705b9352f7c502e1880465b9328607dd69b222805"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/bloodhoundad/azurehound/v2/constants.Version=#{version}")

    generate_completions_from_executable(bin/"azurehound", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azurehound --version")

    assert_match "No configuration file", shell_output("#{bin}/azurehound list 2>&1", 1)
  end
end
