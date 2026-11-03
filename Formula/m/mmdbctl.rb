class Mmdbctl < Formula
  desc "MMDB file management CLI supporting various operations on MMDB database files"
  homepage "https://github.com/ipinfo/mmdbctl"
  url "https://github.com/ipinfo/mmdbctl/archive/refs/tags/mmdbctl-1.5.2.tar.gz"
  sha256 "6dda2fb069eb310bb3a22fe79daf15950f2e87d01bedfd05d4a6fb0df264993f"
  license "Apache-2.0"
  head "https://github.com/ipinfo/mmdbctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "62b3dbc96bbc5b8b8becc293fac30b31f64b4ad452a383f1b279125f3c5bc4e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "62b3dbc96bbc5b8b8becc293fac30b31f64b4ad452a383f1b279125f3c5bc4e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62b3dbc96bbc5b8b8becc293fac30b31f64b4ad452a383f1b279125f3c5bc4e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b18e35d715b4108b76866afec681c09d5dc6a6326c1605cf5699335548ade0fc"
    sha256 cellar: :any,                 x86_64_linux:      "f74bd008593a3da4c9e57e39a4e90a134943967b6cdd554dfc48e21c3610c511"
  end

  depends_on "go" => :build

  resource "test.mmdb", :test do
    url "https://raw.githubusercontent.com/maxmind/MaxMind-DB/02de12f89048db626d04f8865c6fc76eac9a7a6b/test-data/GeoIP2-City-Test.mmdb"
    sha256 "df1eb8e048d3b2561f477cd27f7d642fc25a24767395071d782ae927036818a0"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"mmdbctl", shell_parameter_format: :cobra)
  end

  test do
    testpath.install resource("test.mmdb")

    system bin/"mmdbctl", "verify", testpath/"GeoIP2-City-Test.mmdb"

    output = shell_output("#{bin}/mmdbctl metadata #{testpath}/GeoIP2-City-Test.mmdb")
    assert_match "GeoIP2 City Test Database (fake GeoIP2 data, for example purposes only)", output
  end
end
