class LanOrangutan < Formula
  desc "Self-hosted network scanner and device inventory with a web dashboard"
  homepage "https://github.com/291-Group/LAN-Orangutan"
  url "https://github.com/291-Group/LAN-Orangutan/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "cf6a2ab8fe1363f08d153f32acbcf25b6addb1f2fa16888cab686a4c5fd09bc5"
  license "MIT"

  bottle do
    manifest_sha256 "03a3a34ede6bd212068cd34c2a305e78381a21ee77ea207559f9505cca1485e3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77b7633bfb656aaff0da231edbef1fad22f2f84756bb680a9b914887690bce9a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77b7633bfb656aaff0da231edbef1fad22f2f84756bb680a9b914887690bce9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "77b7633bfb656aaff0da231edbef1fad22f2f84756bb680a9b914887690bce9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "498b2ac2037a3d5a44bf2dd8c736623c6c46ec9f790c5c972f7e2d7d1eefd48a"
    sha256 cellar: :any,                 x86_64_linux:      "8e9a003d298cc8bdda7812a6451ba0f45be9b5b1c9fb16387bc624b1758dfcb0"
  end

  depends_on "go" => :build
  depends_on "nmap"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/291-Group/LAN-Orangutan/internal/cli.Version=#{version}
      -X github.com/291-Group/LAN-Orangutan/internal/cli.Commit=#{tap.user}
      -X github.com/291-Group/LAN-Orangutan/internal/cli.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"orangutan"), "./cmd/orangutan"

    generate_completions_from_executable(bin/"orangutan", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"orangutan", "serve"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    working_dir var
    log_path var/"log/lan-orangutan.log"
    error_log_path var/"log/lan-orangutan.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orangutan version")

    ENV["ORANGUTAN_DATA_DIR"] = testpath/"data"
    system bin/"orangutan", "groups", "add", "Lab"
    assert_match "\"Lab\"", shell_output("#{bin}/orangutan groups --format json")
  end
end
