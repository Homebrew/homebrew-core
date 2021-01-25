class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/releases/download/v3.6.2/pgloader-bundle-3.6.2.tgz"
  sha256 "e35b8c2d3f28f3c497f7e0508281772705940b7ae789fa91f77c86c0afe116cb"
  license "PostgreSQL"
  revision 2
  head "https://github.com/dimitri/pgloader.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7f926192e26b7e8a0e5d269370590d23a1d1c28e2323b6c2001e71088b2b8cd" => :big_sur
    sha256 "89145353b5e7cd483e99f88f9db350f678ee7281ebf06d2e02263d8ffa5a626c" => :catalina
    sha256 "d380bc8ea035e70afaaa5c913cf0ee4e4aedce19d7b29a6545297b59e512d0a8" => :mojave
  end

  depends_on "buildapp" => :build
  depends_on "freetds"
  depends_on "openssl@1.1"
  depends_on "postgresql"
  depends_on "sbcl"

  # From https://github.com/dimitri/pgloader/issues/1218
  # Fixes: "Compilation failed: Constant NIL conflicts with its asserted type FUNCTION."
  patch :DATA

  def install
    system "make"
    bin.install "bin/pgloader"
  end

  def launch_postgres(socket_dir)
    require "timeout"

    socket_dir = Pathname.new(socket_dir)
    mkdir_p socket_dir

    postgres_command = [
      "postgres",
      "--listen_addresses=",
      "--unix_socket_directories=#{socket_dir}",
    ]

    IO.popen(postgres_command * " ") do |postgres|
      ohai postgres_command * " "
      # Postgres won't create the socket until it's ready for connections, but
      # if it fails to start, we'll be waiting for the socket forever. So we
      # time out quickly; this is simpler than mucking with child process
      # signals.
      Timeout.timeout(5) { sleep 0.2 while socket_dir.children.empty? }
      yield
    ensure
      Process.kill(:TERM, postgres.pid)
    end
  end

  test do
    return if ENV["CI"]

    # Remove any Postgres environment variables that might prevent us from
    # isolating this disposable copy of Postgres.
    ENV.reject! { |key, _| key.start_with?("PG") }

    ENV["PGDATA"] = testpath/"data"
    ENV["PGHOST"] = testpath/"socket"
    ENV["PGDATABASE"] = "brew"

    (testpath/"test.load").write <<~EOS
      LOAD CSV
        FROM inline (code, country)
        INTO postgresql:///#{ENV["PGDATABASE"]}?tablename=csv
        WITH fields terminated by ','

      BEFORE LOAD DO
        $$ CREATE TABLE csv (code char(2), country text); $$;

      GB,United Kingdom
      US,United States
      CA,Canada
      US,United States
      GB,United Kingdom
      CA,Canada
    EOS

    system "initdb"

    launch_postgres(ENV["PGHOST"]) do
      system "createdb"
      system "#{bin}/pgloader", testpath/"test.load"
      output = shell_output("psql -Atc 'SELECT COUNT(*) FROM csv'")
      assert_equal "6", output.lines.last.chomp
    end
  end
end
__END__
--- a/local-projects/cl-csv/parser.lisp
+++ b/local-projects/cl-csv/parser.lisp
@@ -31,12 +31,12 @@ See: csv-reader "))
     (ignore-errors (format s "~S" (string (buffer o))))))

 (defclass read-dispatch-table-entry ()
-  ((delimiter :type (vector (or boolean character))
+  ((delimiter :type (or (vector (or boolean character)) null)
               :accessor delimiter :initarg :delimiter :initform nil)
    (didx :type fixnum :initform -1 :accessor didx :initarg :didx)
    (dlen :type fixnum :initform 0 :accessor dlen :initarg :dlen)
    (dlen-1 :type fixnum :initform -1 :accessor dlen-1 :initarg :dlen-1)
-   (dispatch :type function :initform nil :accessor dispatch  :initarg :dispatch)
+   (dispatch :type (or function null) :initform nil :accessor dispatch  :initarg :dispatch)
    )
   (:documentation "When a certain delimiter is matched it will call a certain function
     T matches anything
