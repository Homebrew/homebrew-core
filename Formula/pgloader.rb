class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/releases/download/v3.6.2/pgloader-bundle-3.6.2.tgz"
  sha256 "e35b8c2d3f28f3c497f7e0508281772705940b7ae789fa91f77c86c0afe116cb"
  license "PostgreSQL"
  revision 1
  head "https://github.com/dimitri/pgloader.git"

  bottle do
    sha256 "218a59416c6f94c8e2855b59bf3ca942dbbfe8c3b62665f2dd9561ddd3d00aa8" => :catalina
    sha256 "850897627bcfe4367292696644f24d08674fec75a6a74269bca4b5c5d1d74a69" => :mojave
    sha256 "6abfe60b76b732f4492f898693ab03fac460848dc5c238c89af26720aa273ba3" => :high_sierra
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
