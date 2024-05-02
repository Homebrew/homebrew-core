class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://greenmask.io"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "76a8aaef99762266a1cf1723a98b00490e7bcf4ded4788cd193990954f673c3e"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "909ee01ebe7571dbb36ef2fea9823b8786331765552f148f70f7282dfcf0147e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fafeb41e2db2a146d63cfc1c26e735c2743d983ed8dee31ad5af6214a22dfe4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0aadea009f850c2f278706d3e5c9019ee5e45501d594c7cdf891bb7491093bf6"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4b99503d4cdc19a4beaea0b863401ac1bbe30e92d9579fd6136de9aaea56985"
    sha256 cellar: :any_skip_relocation, ventura:        "16e74f12e6d1a5f0008dbd46861513438a4a1eba0772d1f2e1e8edb08217e9f1"
    sha256 cellar: :any_skip_relocation, monterey:       "1e377f437d61a6b6ee214509b8605cfed6662073fa330e4181bfbfaa83018449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4779f0ad3c9debcd5643ecbc990942407ff5a397f1f618b745d9e668584b92da"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/greenmaskio/greenmask/cmd/greenmask/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/greenmask"

    generate_completions_from_executable(bin/"greenmask", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/greenmask -v")

    (testpath/"config.yml").write <<~EOS
      common:
      pg_bin_path: "/usr/lib/postgresql/16/bin"
      tmp_dir: "/tmp"

      storage:
        s3:
          endpoint: "http://playground-storage:9000"
          bucket: "adventureworks"
          region: "us-east-1"
          access_key_id: "Q3AM3UQ867SPQQA43P2F"
          secret_access_key: "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG"

      validate:
      #  resolved_warnings:
      #    - "aa808fb574a1359c6606e464833feceb"

      dump:
        pg_dump_options: # pg_dump option that will be provided
          dbname: "host=playground-db user=postgres password=example dbname=original"
          jobs: 10

        transformation: # List of tables to transform
          - schema: "humanresources" # Table schema
            name: "employee"  # Table name
            transformers: # List of transformers to apply
              - name: "NoiseDate" # name of transformers
                params: # Transformer parameters
                  ratio: "10 year 9 mon 1 day"
                  column: "birthdate" # Column parameter - this transformer affects scheduled_departure column

      restore:
        pg_restore_options: # pg_restore option (you can use the same options as pg_restore has)
          jobs: 10
          dbname: "host=playground-db user=postgres password=example dbname=transformed"
    EOS
    output = shell_output(bin/"greenmask --config config.yml list-transformers")
    assert_match "Generate random uuid", output
  end
end
