class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.86.3.tar.gz"
  sha256 "6a2778153fcb94efe7951263677b40b03faf8829bc2a4e51ef1a76155e4bc6cd"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6d68b299ad9d4dcf00252e304e3c0d361f6c6b8e83b3f12a2b5631d2b1b4d10"
    sha256 cellar: :any,                 arm64_sequoia: "aa7a82121cbc0ceb2599b790d669e3ad0e8406df47663f8ccfdfc220263acc94"
    sha256 cellar: :any,                 arm64_sonoma:  "cc3656d2f0d336e5a2dd9ede903cea4a9c552df7aceb10b6f07ab972d135aa9c"
    sha256 cellar: :any,                 sonoma:        "aed72dca2a305f3f6565f7c1b9a46313553210d6e99fd958851474847a027419"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6442f54572f33d0c0c38bbcc0a560eb4e8ad6c22ee1fe6f83c3380a0151cc9c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c030a8e081364eb6e9c17fe59f578f9f014dcfd908f16463ba7187704533d1e0"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
    (etc/"dolt").mkpath
    touch etc/"dolt/config.yaml"
  end

  service do
    run [opt_bin/"dolt", "sql-server", "--config", etc/"dolt/config.yaml"]
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
