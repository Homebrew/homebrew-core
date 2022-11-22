class Kubekey < Formula
  desc "Installer for Kubernetes and / or KubeSphere, and related cloud-native add-ons"
  homepage "https://kubesphere.io"
  url "https://github.com/kubesphere/kubekey.git",
      tag:      "v3.0.2",
      revision: "1c395d22e75528d0a7d07c40e1af4830de265a23"
  license "Apache-2.0"
  head "https://github.com/kubesphere/kubekey.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e9aab02083be551a1e3a651026d9ca65a74749708a83879674d57a4beebefa18"
    sha256 cellar: :any,                 arm64_monterey: "b596534e704a537b3691e198e24e72204e760f68d6d3cabc4e109c8466ca05f7"
    sha256 cellar: :any,                 arm64_big_sur:  "006df9a8b7f73fc9cb0124f809ff3f4e7e759934c42e800d418f6532ada78554"
    sha256 cellar: :any,                 monterey:       "43dd5a6599da606ded060e2b2c4165f09a614564ea69979e11549351828eb5c0"
    sha256 cellar: :any,                 big_sur:        "8d36c52bdfed60aca59d1ef4ee93be7f653cc16e54c73d8dc83c4955151b08ad"
    sha256 cellar: :any,                 catalina:       "ab01358b00d84373f70943af071c4d2a609f6540363ea9a331c8634953869770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bdf478e04ba7967b9e09c677830f1b9949706dbb25646fb9ade5b6aef52466d"
  end

  depends_on "go" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubesphere/kubekey/version.gitMajor=#{version.major}
      -X github.com/kubesphere/kubekey/version.gitMinor=#{version.minor}
      -X github.com/kubesphere/kubekey/version.gitVersion=v#{version}
      -X github.com/kubesphere/kubekey/version.gitCommit=#{Utils.git_head}
      -X github.com/kubesphere/kubekey/version.gitTreeState=clean
      -X github.com/kubesphere/kubekey/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"kk"), "./cmd/kk"

    generate_completions_from_executable(bin/"kk", "completion", "--type", shells: [:bash, :zsh], base_name: "kk")
  end

  test do
    version_output = shell_output(bin/"kk version")
    assert_match "Version:\"v#{version}\"", version_output
    assert_match "GitTreeState:\"clean\"", version_output

    system bin/"kk", "create", "config", "-f", "homebrew.yaml"
    assert_predicate testpath/"homebrew.yaml", :exist?
  end
end
