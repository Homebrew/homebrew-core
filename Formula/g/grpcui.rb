class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https://github.com/fullstorydev/grpcui"
  url "https://github.com/fullstorydev/grpcui/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "6f48cad0addd92b922ba7123c0e8700ef3a019a930b3ae8cac2138e62dbd3af1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11d6be3711090bf22cf17550fd88af52d18183a860a6b35bea95d9b2a411d6b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "293d95997d9e110c1305e6c225a3bf3877d869a1aba2f58bffed3b6fbea79bab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c7083ca98cdc61f950b42314f9b3af7aa661ab3ee80c1d1c597a6850aac943f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba16435646cf9e96404f32cbf7f048301c3dcf8f25f90fddc735de07acf91e46"
    sha256 cellar: :any_skip_relocation, ventura:        "92bbb7eb0f029a3bba76702d0de6144fe4694018450f8da0fd46fd464cfed9fe"
    sha256 cellar: :any_skip_relocation, monterey:       "0ea5e14445d823a3dfd6a4141d5098adaa06f627637291e85fca642a52845564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13fe74fd164c670e20ed61d5ff4fa173945063c6cff02ead71ab4ff5ae2c10dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/grpcui"
  end

  test do
    host = "no.such.host.dev"
    output = shell_output("#{bin}/grpcui #{host}:999 2>&1", 1)
    assert_match(/Failed to dial target host "#{Regexp.escape(host)}:999":.*: no such host/, output)
  end
end
