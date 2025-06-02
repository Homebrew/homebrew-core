class Mmdbctl < Formula
  desc "MMDB file management CLI supporting various operations on MMDB database files"
  homepage "https://github.com/ipinfo/mmdbctl"
  url "https://github.com/ipinfo/mmdbctl/archive/refs/tags/mmdbctl-1.4.7.tar.gz"
  sha256 "b871a2d0ad556868ce9610cf819447fc38566aeace7a66294f00ab5544588a77"
  license "Apache-2.0"
  head "https://github.com/ipinfo/mmdbctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32af5fb6ace4686dc1a624dadabb094be9c280f58fad3b10f892a452eeb415a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32af5fb6ace4686dc1a624dadabb094be9c280f58fad3b10f892a452eeb415a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32af5fb6ace4686dc1a624dadabb094be9c280f58fad3b10f892a452eeb415a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8152bb594c50bfea37db1fce61244638710bada48c1cf4e25377018e6b80f9c0"
    sha256 cellar: :any_skip_relocation, ventura:       "8152bb594c50bfea37db1fce61244638710bada48c1cf4e25377018e6b80f9c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b989aa9b091f0af0fb337c856e4ea5ae1cf1ef09f20977f82b5c529d5bfa25d2"
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
