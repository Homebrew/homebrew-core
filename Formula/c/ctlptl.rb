class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.8.37.tar.gz"
  sha256 "cda2ff74208af7ab52965f1bc18b506b9ada7e9fbe063719961e40e4b8f9e4de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0b843454d46dff095fb6cf1973c79ec68e801a7de8798b76400cd9b38c610aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78b08419af31ade90f8c25fde175ef0f29661465c953f6ab6ae6d1bae706089c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "332ac66d3efee5e3706f8033814860376114da9e2cb2346bdd078b9ebf25ef05"
    sha256 cellar: :any_skip_relocation, sonoma:        "47ae9bec7881b35188647fb6ff2fbda3a6d077c72974db11ae210f3c7d078157"
    sha256 cellar: :any_skip_relocation, ventura:       "2c183de8cf1abe1a3f741c10b66035072ec9e7aab30f798396874d8e2594b84c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84d4b9d0c104a6e3aab9955ff52e6ce7b00a3ce732a2399aa259dfb5c3369277"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_empty shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
