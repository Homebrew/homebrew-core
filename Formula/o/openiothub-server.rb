class OpeniothubServer < Formula
  desc "Server for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub/server-go"
  url "https://github.com/OpenIoTHub/server-go.git",
      tag:      "v1.2.2",
      revision: "f1f22eafad275bb3f4fef9a16c84aa4621660af1"
  license "MIT"
  head "https://github.com/OpenIoTHub/server-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc09588b08d156a35e0e70cc1b7132093078d60d0f23165db9fe04d9374fa8ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91c90cd81dc422d572332312133ac6c3ab565c23062b575525631a2f7ec84f54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10d2e36f0eedda408df08a738bea3d90db785107365fdaf5d0be7e2b8e975180"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bb3373df388303977b2097676ba6c2a30909788fa5eb67932e2b977a5ca0c2a"
    sha256 cellar: :any_skip_relocation, ventura:        "dde52cc3f47124149dbab1ff6fd87768f11a2ad2d74df16598ff2914c863ae26"
    sha256 cellar: :any_skip_relocation, monterey:       "e7279b40eab7cdc889d77efd66efc3d7b608c28582cd976c277e9a879c6d08f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b48139c572567631859520bc6f52e3669ff043e200227df1097701dd6a6d8e7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]

    (etc/"server-go").mkpath
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
    bin.install_symlink bin/"openiothub-server" => "server-go"
    etc.install "server-go.yaml" => "server-go/server-go.yaml"
  end

  service do
    run [opt_bin/"openiothub-server", "-c", etc/"server-go.yaml"]
    keep_alive true
    log_path var/"log/openiothub-server.log"
    error_log_path var/"log/openiothub-server.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openiothub-server -v 2>&1")
    assert_match "config created", shell_output("#{bin}/openiothub-server init --config=server.yml 2>&1")
    assert_predicate testpath/"server.yml", :exist?
  end
end
