class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.7.5.tar.gz"
  sha256 "6cbf434cef66132337dda09250b25313da3b2a56eb4cbc8dda8ae8404eff59ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "719613c9b090bdddc48ffebe3ca13347fcaf8ccdadbcddee6bbec4367dbc7795"
    sha256 cellar: :any_skip_relocation, big_sur:       "77385699141202354e27dbfbe1d57c936e4eec4beb1c5f7537f29db4cfc57602"
    sha256 cellar: :any_skip_relocation, catalina:      "d5305ec74f29526e6e7b01632dda0e48b0af397d9a65baf233db4da48f96ee8a"
    sha256 cellar: :any_skip_relocation, mojave:        "00f1f34756eadc57f39945a00bc4e8c9e8ff2beefafbb58052667c2611e29e0f"
    sha256 cellar: :any_skip_relocation, high_sierra:   "42d2757b01271ef6c14de5441b3c65507538388db1e00e69f322272a5ba5b59c"
    sha256 cellar: :any_skip_relocation, sierra:        "222a5586670fec7643e9e7651f0b1fa82ff012048bd29b959ac720743f1a1a4f"
    sha256 cellar: :any_skip_relocation, el_capitan:    "c274701a545e5a4885995718f5f01ca6df2f9c6b9a143d4ffcf46b1771ac4cbc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
