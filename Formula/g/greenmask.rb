class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://greenmask.io"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "de1edf14b94960daf1d0974a358c395acbb67f0560d8da23d093ab4e452ab9ec"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6238248a1910eaae0ba5caa17fbc2b485d78daecd6e432b56587e1f312d01939"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c669ee957e42392afb372e15ab973265b4e54c8ec91ed1fdc44e3042333e038"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2359990a6d66324e2443a79a11bc4444a1568e3fd838cddd7470138ce41b13f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f89d0df8fc4e15711e3458b47bd5cd89f8ecc2087c87533909166dfec936dd29"
    sha256 cellar: :any_skip_relocation, ventura:        "6c5dd5e3a99196f87ca96244ac7ba1b6c032e5ea61d73aefd44959d3febded6a"
    sha256 cellar: :any_skip_relocation, monterey:       "8171f77b52fb755d48a7e14ad0a3804753c94b6d43e70f0078a28dd8580a7455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "169042f04f8acef1a16f8802a5eacf39b1bb23a3bc812485b261a43ada8c45f2"
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
