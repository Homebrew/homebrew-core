class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/refs/tags/v0.33.3.tar.gz"
  sha256 "1707aa5a871f3551a28cf8e5aca047b94658ed620fffe6b10de6e927c1c9bb37"
  license "Apache-2.0"
  head "https://github.com/sunny0826/kubecm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4677eeffb17078b997b8ed54382d2198cf6d09ba0dd458f9c50368c777eb1270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4677eeffb17078b997b8ed54382d2198cf6d09ba0dd458f9c50368c777eb1270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4677eeffb17078b997b8ed54382d2198cf6d09ba0dd458f9c50368c777eb1270"
    sha256 cellar: :any_skip_relocation, sonoma:        "bca21762b19ee29425ad2bce7ec7cf771a2270bf963c37421bed0ac71068b868"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1240e7ca465f3d2613e217ac3737f24646eeeb6ccae40049f2d9a517b1bc4b83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61d6bd4674914a601d5d87a95c0e8de9d83c80e12659cbd3d2a4cc3e738f813e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
