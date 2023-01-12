class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.4.tar.gz"
  sha256 "abed2585a39a0f341a207fe2a67f847a6ac438490f9dc310717bc9877ea6b95d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3016c3f897d4b91c4256213fa1c38a58e9f4f4b86338c54c381e60ef1420e35f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1125dbbcba8511413205ca751c4c8a1f8e27a0e64559189697926a953b66a09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9a806b2d5fe5da4472d99e7a11bb9473ffde469ba49328fd5de19b44ab435d7"
    sha256 cellar: :any_skip_relocation, ventura:        "f1a8ae0af61d0d27329b0f75b3d1009830fda2a3bee5a1d09fa69c2831aa5363"
    sha256 cellar: :any_skip_relocation, monterey:       "b31ec476396f98d9907986f72d002a0d837f20064a5c8fb5c059c4ceab31d0a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ce7a42ebff379f6336973ddccd541b9974545f9a78ffe5748062655fdfe5119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "700a7bbe8a9c4277fdfb61b49a43b170a18c2d0cd2d033c19dd57476b2d9e210"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
