class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.18.7.tar.gz"
  sha256 "fb66b62bc136a6ec72e8e87856a864f96fb66e3e0a966927fa30711753e390af"
  license "Apache-2.0"
  head "https://github.com/cilium/cilium-cli.git", branch: "main"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4307716b4140cfe5408cddeffaa100d301bd0bc3b1eff58863c52171dbed5675"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf05f9b4081dd2f81a303820a2e9aa7a6ffaa9244729477a87e2983d69dae7aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ec04fc77832cf247abb461000c84f811fa9bf6a5a5f6cee83f692ae01370836"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bfee4e46d895be7a34d222bc63ea4ef65a81b626cb39638e909d5fa9c639baf"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd83d28dbe2c47fb1f0493f09ee2a25e4cef92cb3414ccd31030ac251be86952"
    sha256 cellar: :any_skip_relocation, ventura:       "d72ba63144739ce07f50f0e3c7ef40fc2a6bcb975c92168829b99cf58d313413"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04d57491f7ccf02cdda86ad1d80d141bf57217f4f294a3853834fe0f236e05c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03a951a73f9486b352ce8539930d97c0fdecff02f7bd94ea5d9548ad8d01785b"
  end

  depends_on "go" => :build

  def install
    cilium_version_url = "https://raw.githubusercontent.com/cilium/cilium/main/stable.txt"
    cilium_version = Utils.safe_popen_read("curl", cilium_version_url).strip

    ldflags = %W[
      -s -w
      -X github.com/cilium/cilium/cilium-cli/defaults.CLIVersion=v#{version}
      -X github.com/cilium/cilium/cilium-cli/defaults.Version=#{cilium_version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cilium"), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
