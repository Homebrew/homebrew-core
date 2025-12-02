class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.78.5.tar.gz"
  sha256 "94d73a42ee8293f3a80e0dbfe06bb0b0944067f9669e5c315af38067e4a4ccd1"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67acee828ad6e4e8a6bcdfd40642ca35bbbebb76a41b6d3cdb72b134d1131a22"
    sha256 cellar: :any,                 arm64_sequoia: "ad9f985a4f85314115c3e04f4d3966aad9c01967749f1b57ec2bf637c7204e73"
    sha256 cellar: :any,                 arm64_sonoma:  "9e7b55b9447980b65d65faeb1b2703ae51ac2a5fc1f29b0c75a64d762dc68556"
    sha256 cellar: :any,                 sonoma:        "aef058148f2e2ac48a020ec2dbe4014ef4aaa13af7394cc7f813a4476f112950"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "940b859b8bd5c2a8c0ef781122bb9ccb213097244b57c18d65656a990138315d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2912fcabfe5a17673783fb8e561691c919bf113e4ba8b241ada120afbc6e8189"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
  end

  service do
    run [opt_bin/"dolt", "sql-server"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
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
