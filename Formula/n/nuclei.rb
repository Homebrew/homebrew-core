class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "977726c98398fc3f9348bc7ffbf3704b5eedcaa754f7f964a8de25d3c9ca6c59"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efff4f9adafb6a2143892ac5570719dae8d806e5abfa19d6fe73226a5bed9249"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b43d386f4bb59bc7f0b75e032f3f541930c51f4fe776b306f386b4db069f4b71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40fce3d43411610c5de01704f2a8544b718e14f13fe1c9ad2db245f2f24ed78a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6008abae754a85fb8f01345f29a5e171a4d28e094942b6a06801de754c430196"
    sha256 cellar: :any_skip_relocation, ventura:       "b8798fa90d1dbf21f087d210acf4bf654615d979b768d0c4bf7d1b7e45dcda48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "409f6be4bba558360de818fce35c77b964347285af84d110de92372289bda4aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d04fa40bdbf3658aff8756550ac595f1ee260710a90f32b573eca90b9b7bf4c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
