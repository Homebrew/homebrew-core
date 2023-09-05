class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.12.9.tar.gz"
  sha256 "66518c4eb45341f940ce33d77e767c156d2dab7a755ff50a3b9fe8d20ac58adb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6753afc3c9272f863a787d92cd4c3c0612961109394229e99388c45149d4eb47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba7976dd0cb9bba989d949bd5bb52e0d59d70b22919e153a6333401370a274c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0c256bdbf9ac222c325f86844326534f43c0ba32b18b6e12362412b10599161"
    sha256 cellar: :any_skip_relocation, ventura:        "44e86b8305c13b846d17f1cf03db942c0924fda730abaa880d03cad9aa46251c"
    sha256 cellar: :any_skip_relocation, monterey:       "0ba014eb10ed1af43e4be7247b14e56585371e09c3095d0d8e22ad58f521cb7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "64190d38e6928d90eeccdb639915dc2fc425e347519128496fc08e021674bff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8798e4e83012b2dbaf077d097234e0cc27a62a8bd5628c933bcc4f6ecd7bf426"
  end

  depends_on "go" => :build

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    io = IO.popen("#{bin}/cloudprober --logtostderr", err: [:child, :out])
    io.any? do |line|
      line.include?("Initialized status surfacer")
    end
  end
end
