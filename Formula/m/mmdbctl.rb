class Mmdbctl < Formula
  desc "MMDB file management CLI supporting various operations on MMDB database files"
  homepage "https://github.com/ipinfo/mmdbctl"
  url "https://github.com/ipinfo/mmdbctl/archive/refs/tags/mmdbctl-1.4.8.tar.gz"
  sha256 "373154b545a9f940738868f7e2259c89803dc966646e7b8c599d26b703424d80"
  license "Apache-2.0"
  head "https://github.com/ipinfo/mmdbctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d83aff861970e82984f2a19c2fe0b969a786f5f2133148bfb51c3d88646426a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d83aff861970e82984f2a19c2fe0b969a786f5f2133148bfb51c3d88646426a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d83aff861970e82984f2a19c2fe0b969a786f5f2133148bfb51c3d88646426a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d83aff861970e82984f2a19c2fe0b969a786f5f2133148bfb51c3d88646426a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bce3a893ebc1b01a1dbe6bcc7f972b634f4e463d7244373ff4dfb778a1639614"
    sha256 cellar: :any_skip_relocation, ventura:       "bce3a893ebc1b01a1dbe6bcc7f972b634f4e463d7244373ff4dfb778a1639614"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd2829f9d0625c9515220cefee9a09f1046b91e70b61434a0f8cd85d8df18fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fec967e1d52cb9782b28147f9c503a135d4b2ed175895ea79c139bdb59583b41"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"mmdbctl", "completion")
  end

  test do
    resource "test.mmdb" do
      url "https://raw.githubusercontent.com/maxmind/MaxMind-DB/02de12f89048db626d04f8865c6fc76eac9a7a6b/test-data/GeoIP2-City-Test.mmdb"
      sha256 "df1eb8e048d3b2561f477cd27f7d642fc25a24767395071d782ae927036818a0"
    end

    testpath.install resource("test.mmdb")

    system bin/"mmdbctl", "verify", testpath/"GeoIP2-City-Test.mmdb"

    output = shell_output("#{bin}/mmdbctl metadata #{testpath}/GeoIP2-City-Test.mmdb")
    assert_match "GeoIP2 City Test Database (fake GeoIP2 data, for example purposes only)", output
  end
end
