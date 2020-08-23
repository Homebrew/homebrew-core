class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v2.1.4.tar.gz"
  sha256 "444e109091ddc49e00277e38ddf9456a53243ab70f2560ab927f4d35b53555f4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d310d5c7a3596a17612fd5b56d6c321129ecfae40d4fa7dc5032056c863b4dc3" => :catalina
    sha256 "8b48f7520edfa1b74124b848de69802f127d476968a7c5471bd6174a43fc9899" => :mojave
    sha256 "6ea27e3eed1bbf53401a81d55d138e1f808a9cfb52ca857316b1c371258b9c34" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "rpm"
  depends_on "xz"

  def install
    system "go", "build", *std_go_args, "./cmd/clair"
    (etc/"clair").install "config.example.yaml" => "config.yaml"
  end

  test do
    cp etc/"clair/config.yaml", testpath
    output = shell_output("#{bin}/clair -config=config.yaml", 1)
    # requires a Postgres database
    assert_match "pgsql: could not open database", output
  end
end
