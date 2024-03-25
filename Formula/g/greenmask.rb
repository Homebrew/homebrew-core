class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://greenmask.io"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "de1edf14b94960daf1d0974a358c395acbb67f0560d8da23d093ab4e452ab9ec"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b81c16290a26e3bb28304e77349d20494b504f7189034b3cca8ac87ba2252535"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "366f8a90585fe02f488d77817fed6f0c6a82e40c1eed10dd776d40eb464f688e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0efeb1718fefc7fa17ae474721af54cf33413a26902180be0882b42e97c36ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "36cfa51bcef23a10e87bba7a77b288ad3d849fce9e960f1505c1f6558f195209"
    sha256 cellar: :any_skip_relocation, ventura:        "8681a80f0fa4b478667ede41b21cdd47452a2d3b90ea21f817cb28513e0126c9"
    sha256 cellar: :any_skip_relocation, monterey:       "52780c67b7675f501bf187f5628e28afa735c66965affe42bc24bbd637a0bc42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c56b07f6f743788ba1ed317b118f0d365d0c4b8a6ec4d4360e192e21049c3a95"
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
