class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.6.4.tar.gz"
  sha256 "dd4e1d378c29f1c43b481d5fb8020252d4a5af61e95119dd72d0dd4c4a728313"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "31c43922bd32cfd84c3930a9b53019fec8a54da7bcb924281e2b390065973f6f"
    sha256 cellar: :any, arm64_sequoia: "2961209dcdc51a410036fd96488db2fc5139be432b4019a254f3c522e68c1df4"
    sha256 cellar: :any, arm64_sonoma:  "8dd84771f3285f6d40a0c73f9a57407f4968aa8587db9c714452e866cd9a2342"
    sha256 cellar: :any, sonoma:        "ac805ca378a9196bf6b8f2b63cb13cef299e56e94ed452b1ef16c50ab81bfa46"
    sha256               arm64_linux:   "a740333c5a2aeb7b6aab26abb80987ff7c30d465c8ea8aab83d313bed6bcf376"
    sha256               x86_64_linux:  "fcdc12e3b96e0dd0abbc0c21ec38ee87f06795f05925a78013f7f7cba20862ec"
  end

  depends_on "elixir" => :build
  depends_on "postgresql@18" => :test
  depends_on "erlang"
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["MIX_ENV"] = "prod"
    ENV["MIX_TARGET"] = "application"

    cd "packages/sync-service" do
      system "mix", "deps.get"
      system "mix", "compile"
      system "mix", "release"
      libexec.install Dir["_build/application_prod/rel/electric/*"]
      bin.write_exec_script libexec.glob("bin/*")
    end

    # Remove non-native libraries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch
    libexec.glob("lib/ex_sqlean-0.8.8/priv/*").each do |f|
      rm_r(f) unless f.basename.to_s.match?("#{os}-#{arch}")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/electric version")

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    ENV["DATABASE_URL"] = "postgres://#{ENV["USER"]}:@localhost:#{port}/postgres?sslmode=disable"
    ENV["ELECTRIC_INSECURE"] = "true"
    ENV["ELECTRIC_PORT"] = free_port.to_s
    ENV["LC_ALL"] = "C"
    ENV["PGDATA"] = testpath/"test"

    system pg_ctl, "initdb", "--options=-c port=#{port} -c wal_level=logical"
    system pg_ctl, "start", "-l", testpath/"log"

    begin
      (testpath/"persistent/shapes/single_stack/.meta/backups/shape_status_backups").mkpath

      spawn bin/"electric", "start"
      sleep 5 if OS.mac? && Hardware::CPU.intel?

      tries = 0
      begin
        output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
        assert_match "active", output
      rescue Minitest::Assertion
        # https://github.com/electric-sql/electric/blob/main/website/docs/guides/deployment.md#health-checks
        raise if !output&.match?(/starting|waiting/) || (tries += 1) >= 3

        sleep 10
        retry
      end
    ensure
      system pg_ctl, "stop"
    end
  end
end
