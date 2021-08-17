class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.2.1.tar.gz"
  sha256 "eb4989edad8104880a175a6462a22185c9b5adf682074f02c37415b083e382c0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "3a77508093018054673ce175b5f2cb19706dfe30f73e4b6ba00688e8a647a495"
    sha256 cellar: :any_skip_relocation, catalina:     "b4039cf1c18b2acffa43803b41837515030c4d29a88f0b4b16e44f287d0d00fc"
    sha256 cellar: :any_skip_relocation, mojave:       "54e4e434f667f01e71c6f32962e5ab37ad0d4826013cbab6218a6d21acd32ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "267f82d7ed77b95c30b4d22e0a9ffdc85ea27ba631cd7fd349da98b5d9357760"
  end

  depends_on "go" => :build
  depends_on "rpm"
  depends_on "xz"

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/clair"
    (etc/"clair").install "config.yaml.sample"
  end

  test do
    cp etc/"clair/config.yaml.sample", testpath
    output = shell_output("#{bin}/clair -conf #{testpath}/config.yaml.sample -mode combo 2>&1", 1)
    # requires a Postgres database
    assert_match "service initialization failed: failed to initialize indexer: failed to create ConnPool", output
  end
end
