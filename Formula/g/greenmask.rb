class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://greenmask.io"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "39699698cd1326fec8f075475f2aeda225f30e701149a5b366730856c7e39dea"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c6b35750b814568124e45bc324aa874cc745a891b6480e5a0d468f348d1b8e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47e18ac57d1cd27ad323e42b576d33b7c8d1b5579f13c236c0170616cdd36f08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58b62640ef7f7f7e4f2618191f701c695a85938639dbcb1d1ea842dc0ab3c642"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cdb47525685b069295250bd6ad48d3514a1ea512d61f56ac442e7a25ae7d46e"
    sha256 cellar: :any_skip_relocation, ventura:        "4ee74ceea5179be089ba182178d1cafd7f04208e9176fac204f0ee78c8c5b884"
    sha256 cellar: :any_skip_relocation, monterey:       "250d4696ae64f5a85adf351fa45f9373805cb0db1bd11d9e88904596e945fd72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e482969bf222069ef4e48dfb661dac9bf5cf8cf538d55eadc72f167676e1255e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/greenmaskio/greenmask/cmd/greenmask/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/greenmask"

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
