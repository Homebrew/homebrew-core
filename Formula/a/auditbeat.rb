class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.5.7",
      revision: "9455ccba703306aae4ed36b86a03976c963c0186"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    manifest_sha256 "7309e6706493b90176b613f05799a07dd3e601e1e0f20b2df7ce54e3a238e4fc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aab15756dc41057aabb28f6c189c8cb9b50a575f2787fe9e7dbbcbdf5da41911"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "adc4cbf084f2ed3de38ebd3d05333ac75fe67da5c9b57e1a1587276726f0b395"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7eb483d1fb42e453a614f8d2c41056023cd0380441287b7b365686f0b5fce24e"
    sha256 cellar: :any,                 arm64_linux:       "67938cd4baa9c4e3d467dc0f9ba375910e342f62e89022e613f782ef303644a3"
    sha256 cellar: :any,                 x86_64_linux:      "2870393ca4f106fab88c1eaec1c210892e5e5014b63c3d2bdb9044efecbf9469"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    # remove non open source files
    rm_r("x-pack")

    cd "auditbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "devtools.GenerateModuleIncludeListGo, Docs)",
                               "devtools.GenerateModuleIncludeListGo)"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["auditbeat.*", "fields.yml"]
      (libexec/"bin").install "auditbeat"
      prefix.install "build/kibana"
    end

    (bin/"auditbeat").write <<~SHELL
      #!/bin/sh
      exec #{libexec}/bin/auditbeat \
        --path.config #{etc}/auditbeat \
        --path.data #{var}/lib/auditbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/auditbeat \
        "$@"
    SHELL

    chmod 0555, bin/"auditbeat"
    generate_completions_from_executable(bin/"auditbeat", "completion", shells: [:bash, :zsh])

    (var/"lib/auditbeat").mkpath
    (var/"log/auditbeat").mkpath
  end

  service do
    run opt_bin/"auditbeat"
  end

  test do
    (testpath/"files").mkpath
    (testpath/"config/auditbeat.yml").write <<~YAML
      auditbeat.modules:
      - module: file_integrity
        paths:
          - #{testpath}/files
      output.file:
        path: "#{testpath}/auditbeat"
        filename: auditbeat
    YAML

    with_test_process(bin/"auditbeat", "--path.config", testpath/"config", "--path.data", testpath/"data") do
      sleep 5
      touch testpath/"files/touch"
      sleep 10

      assert_path_exists testpath/"data/beat.db"

      output = JSON.parse((testpath/"data/meta.json").read)
      assert_includes output, "first_start"
    end
  end
end
