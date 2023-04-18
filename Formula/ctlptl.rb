class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.18.tar.gz"
  sha256 "4300fa534ab39bf0a4f1e989fe4f5a3980fffd165bf943dd7907e79aac720995"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b10ec822da5aaca0adbdef0b1b9ce50b6b766047ac933ffca122dbe60270efb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dd0bf3c2bb66ee5383d7fe642f155bb71ba7578b30cb79d288d51a1d067bab1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "511f643b269e3d7bc62bcc849b49708ecbed9e0bd4569983f156b66baa248daf"
    sha256 cellar: :any_skip_relocation, ventura:        "c10a4283a331bf1151420ee0b5361f3de6728a5f8a460a708c13b08bf1011b55"
    sha256 cellar: :any_skip_relocation, monterey:       "eadf867f4ace60b11ceba3568d650fe93ead23cd5b6137d0e3e3e3431c098faa"
    sha256 cellar: :any_skip_relocation, big_sur:        "748deb70190b9f1abe4bb001366641274de650719488f3d7a0fa005110467f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bd67fc129837317a4fe1701a99c29b5758a7771edf8628d0143ff1b69e5b898"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
