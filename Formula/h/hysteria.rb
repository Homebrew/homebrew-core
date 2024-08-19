class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.5.1.tar.gz"
  sha256 "6908944c816fa24a4cd291982c5ba76fda5774d713c6c122da8ac2db4a6b13b1"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ed03346365a12040823d685386d635529347b7a66f8f5d545e8597aeca34be8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ed03346365a12040823d685386d635529347b7a66f8f5d545e8597aeca34be8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ed03346365a12040823d685386d635529347b7a66f8f5d545e8597aeca34be8"
    sha256 cellar: :any_skip_relocation, sonoma:         "445f09ced2330c0538434c205f490906f604ac65593df4aae1176de68d288caf"
    sha256 cellar: :any_skip_relocation, ventura:        "445f09ced2330c0538434c205f490906f604ac65593df4aae1176de68d288caf"
    sha256 cellar: :any_skip_relocation, monterey:       "445f09ced2330c0538434c205f490906f604ac65593df4aae1176de68d288caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b63a625a9a56242bd1998e02aa6787d9879c578422cf40ecc5aa77dfbb74ddb"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/apernet/hysteria/app/v2/cmd"
    ldflags = %W[
      -s -w
      -X #{pkg}.appVersion=v#{version}
      -X #{pkg}.appDate=#{time.iso8601}
      -X #{pkg}.appType=release
      -X #{pkg}.appCommit=#{tap.user}
      -X #{pkg}.appPlatform=#{OS.kernel_name.downcase}
      -X #{pkg}.appArch=#{Hardware::CPU.arch}
    ]
    system "go", "build", *std_go_args(ldflags:), "./app"

    generate_completions_from_executable(bin/"hysteria", "completion")
  end

  service do
    run [opt_bin/"hysteria", "--config", etc/"hysteria/config.yaml"]
    run_type :immediate
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"config.yaml").write <<~EOS
      listen: :#{port}
      acme:
        domains:
          - your.domain.com
        email: your@email.com

      obfs:
        type: salamander
        salamander:
          password: cry_me_a_r1ver
    EOS
    output = shell_output("#{bin}/hysteria server --disable-update-check -c #{testpath}/config.yaml 2>&1", 1)
    assert_match "maintenance	started background certificate maintenance", output

    assert_match version.to_s, shell_output("#{bin}/hysteria version")
  end
end
