class Plow < Formula
  desc "High-performance and real-time metrics displaying HTTP benchmarking tool"
  homepage "https://github.com/six-ddc/plow"
  url "https://github.com/six-ddc/plow/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "0ae69218fc61d4bc036a62f3cc8a4e5f29fad0edefe9e991f0446f71d9e6d9ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11c30ecb6a22b06e66440b72505506dc53b0e88e93a6c78aa6431ec01c695a7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95bcacbe5e2365ee02b20f50b0609284ec45c16735bf770e3d4d1e9780855456"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0cef52ae418363789cabb8e8ebf61e0ed8b3e1583c2c824021af33e23d9adff"
    sha256 cellar: :any_skip_relocation, ventura:        "4e044135f1da21cfe2ea2d2148ac796f6b5eb5945ddd1975e2efd65f0c5d967c"
    sha256 cellar: :any_skip_relocation, monterey:       "c7964c4b495698886328bfd10dd83c5295fe25e3c704725954713e7a0c46aff0"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf726164d5c53c61efdd3087164201ebd3b8232a18dee414edd691a53b514f1b"
    sha256 cellar: :any_skip_relocation, catalina:       "e3b8f6c2f84ab9b4d2bff2087c7daf59143f98141dac1d4d56e466a9c0839b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43f1369e3579ddb48a31eb7b987543ee4dfdcc56d79238462c1285b91727c313"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = "2xx"
    assert_match output.to_s, shell_output("#{bin}/plow -n 1 https://httpbin.org/get")
  end
end
