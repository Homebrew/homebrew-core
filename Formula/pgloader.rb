class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/archive/v3.3.2.tar.gz"
  sha256 "09408a976ca1e474e5461db766e0a1efef446303cb744ec3748356b98cf0efbd"
  revision 1
  head "https://github.com/dimitri/pgloader.git"

  bottle do
    sha256 "baca983479adca1a1a8165d0338c9ee910c298785a9f82ac675b423fb4c3ec89" => :sierra
    sha256 "7c59c87a0812a9706a05338b0b330455d32d41c012f947f8d5e8069ea81fbdd0" => :el_capitan
    sha256 "f5efc890f63a81454789969479f91b7ee6ed8318d89ea69f8e25158faa38dd8a" => :yosemite
  end

  depends_on "sbcl"
  depends_on "freetds"
  depends_on "buildapp" => :build
  depends_on :postgresql => :recommended

  # Resource stanzas are generated automatically by quicklisp-roundup.
  # See: https://github.com/benesch/quicklisp-homebrew-roundup

  resource "alexandria" do
    url "https://beta.quicklisp.org/archive/alexandria/2016-12-04/alexandria-20161204-git.tgz"
    sha256 "c41df5956886db8d66f6a5d3e5362f606f2805af44fea567175afca9e1ac755c"
  end

  resource "anaphora" do
    url "https://beta.quicklisp.org/archive/anaphora/2011-06-19/anaphora-0.9.4.tgz"
    sha256 "5e7334e0b498cf4c01cf767f6f7e2be6a01895cc6f80d7fcae6d311fee43983f"
  end

  resource "asdf-finalizers" do
    url "https://beta.quicklisp.org/archive/asdf-finalizers/2015-06-08/asdf-finalizers-20150608-git.tgz"
    sha256 "2f1d76bea6831ca3873762f2245529db38e8633caa76bd8e15882fbeaf0e1c7f"
  end

  resource "asdf-system-connections" do
    url "https://beta.quicklisp.org/archive/asdf-system-connections/2014-02-11/asdf-system-connections-20140211-git.tgz"
    sha256 "df8bf8fcb0f33535137dfb232183387bef63ae713820c7305d921e5fad9a9669"
  end

  resource "babel" do
    url "https://beta.quicklisp.org/archive/babel/2015-06-08/babel-20150608-git.tgz"
    sha256 "6536bb4b426464151dfa476495bede44da5d67165e8d1179238ce731e6e1625b"
  end

  resource "bordeaux-threads" do
    url "https://beta.quicklisp.org/archive/bordeaux-threads/2016-03-18/bordeaux-threads-v0.8.5.tgz"
    sha256 "edaedd450d9267b0a578c9da421fdc96e5f93b119d1502abb1d428e646eb0127"
  end

  resource "cffi" do
    url "https://beta.quicklisp.org/archive/cffi/2016-10-31/cffi_0.18.0.tgz"
    sha256 "ff5ff69b6de2a73ff7c8d4c81207f600ad4fee8791a41d61e2f1b04453a78c3c"
  end

  resource "chipz" do
    url "https://beta.quicklisp.org/archive/chipz/2016-03-18/chipz-20160318-git.tgz"
    sha256 "4620842f94c9431379e9e7e4f27c46381e1730fb1a2c187b39600ed2267afab6"
  end

  resource "chunga" do
    url "https://beta.quicklisp.org/archive/chunga/2014-12-17/chunga-1.1.6.tgz"
    sha256 "efd3a4a1272cc8c04a0875967175abc65e99ff43a5ca0bad12f74f0953746dc7"
  end

  resource "cl+ssl" do
    url "https://beta.quicklisp.org/archive/cl+ssl/2016-12-08/cl+ssl-20161208-git.tgz"
    sha256 "1a9efc7af99a435de6b2a76e5638f98c61f93707921d51cbed2f41d7b2503d75"
  end

  resource "cl-abnf" do
    url "https://beta.quicklisp.org/archive/cl-abnf/2015-06-08/cl-abnf-20150608-git.tgz"
    sha256 "0799bfdc43b7c645934af8c190e58d4d0fac3973ec669ef2feeae0b20f2ca903"
  end

  resource "cl-base64" do
    url "https://beta.quicklisp.org/archive/cl-base64/2015-09-23/cl-base64-20150923-git.tgz"
    sha256 "17fab703f316d232b477bd2f8b521283cc0c7410f9b787544f3924007ab95141"
  end

  resource "cl-containers" do
    url "https://beta.quicklisp.org/archive/cl-containers/2015-09-23/cl-containers-20150923-git.tgz"
    sha256 "9f02adedb39b4cab31047af7153ee46626009a8305d6fe10b79ccf3d2dd77e66"
  end

  resource "cl-csv" do
    url "https://beta.quicklisp.org/archive/cl-csv/2015-06-08/cl-csv-20150608-git.tgz"
    sha256 "b6a1db0a10937dd1e38247eee2b4aa055a4ca4a65eb93b752a1a2f3d21e02833"
  end

  resource "cl-db3" do
    url "https://beta.quicklisp.org/archive/cl-db3/2015-03-02/cl-db3-20150302-git.tgz"
    sha256 "b1ffd5c0d0e3eca1a505e20e0c4e888a2ec87f37faa9f1fc62adefc6ceba8d57"
  end

  resource "cl-fad" do
    url "https://beta.quicklisp.org/archive/cl-fad/2016-08-25/cl-fad-0.7.4.tgz"
    sha256 "3d6d30910217d11bfcef0c2805c9c79e0946bf2696f057bd2efbe66d8c2c77ab"
  end

  resource "cl-interpol" do
    url "https://beta.quicklisp.org/archive/cl-interpol/2016-09-29/cl-interpol-0.2.6.tgz"
    sha256 "0bc1d45179d4295ee25a012558f7fd167724c9c74b1a7b3e74be3b7217f1519c"
  end

  resource "cl-ixf" do
    url "https://beta.quicklisp.org/archive/cl-ixf/2016-09-29/cl-ixf-20160929-git.tgz"
    sha256 "fe62143b034beab6a765649b6111e8a861436305c3cde4183491fb095d035342"
  end

  resource "cl-log" do
    url "https://beta.quicklisp.org/archive/cl-log/2013-01-28/cl-log.1.0.1.tgz"
    sha256 "4d7840b9e3bf5a979f780ba937f4e268c73db48e2f91f6c7c541d86e3ac0ab71"
  end

  resource "cl-markdown" do
    url "https://beta.quicklisp.org/archive/cl-markdown/2010-10-06/cl-markdown-20101006-darcs.tgz"
    sha256 "3c1da678be4f7ee71c245fafa56c1b6f4d3e49e7c6d5cc9b5aafc30abf3e3bc3"
  end

  resource "cl-mssql" do
    url "https://beta.quicklisp.org/archive/cl-mssql/2013-10-03/cl-mssql-20131003-git.tgz"
    sha256 "d34ada2cdabd305fd1d76a02ed60eaf4de02cd2e895060208b41d801c94373fa"
  end

  resource "cl-ppcre" do
    url "https://beta.quicklisp.org/archive/cl-ppcre/2015-09-23/cl-ppcre-2.0.11.tgz"
    sha256 "626d4e1f78659d0b6e4d675c94e39afb1f602427724c961b1e4f029b348f4cb6"
  end

  resource "cl-sqlite" do
    url "https://beta.quicklisp.org/archive/cl-sqlite/2013-06-15/cl-sqlite-20130615-git.tgz"
    sha256 "105333bbdccc3c2ab76ce4a35c63e6b27ac8a7a0967971c4addd666df7766135"
  end

  resource "cl-unicode" do
    url "https://beta.quicklisp.org/archive/cl-unicode/2014-12-17/cl-unicode-0.1.5.tgz"
    sha256 "d690480a82bfaa8d5dba29b68bc24f13e4e485f825904e5822879a280bc6a5c9"
  end

  resource "cl-utilities" do
    url "https://beta.quicklisp.org/archive/cl-utilities/2010-10-06/cl-utilities-1.2.4.tgz"
    sha256 "07a9318732d73b5195b1a442391d10395c7de471f1fe12feedfe71b1edbd51fc"
  end

  resource "closer-mop" do
    url "https://beta.quicklisp.org/archive/closer-mop/2016-10-31/closer-mop-20161031-git.tgz"
    sha256 "a514e5736dc960bef8ec0662cb65dbd5ac8b7dc92a3a79ffbc043cd0af2298ef"
  end

  resource "command-line-arguments" do
    url "https://beta.quicklisp.org/archive/command-line-arguments/2015-12-18/command-line-arguments-20151218-git.tgz"
    sha256 "d0fba1c0ac361aab4273425079945ee1ac8e7d7e7b9a960026a8c999e41edb1f"
  end

  resource "drakma" do
    url "https://beta.quicklisp.org/archive/drakma/2015-10-31/drakma-2.0.2.tgz"
    sha256 "5f40ae3c8c8cabb834234a17c8f89dd8cc35cc104b89a8f86636b4ee5280fcae"
  end

  resource "dynamic-classes" do
    url "https://beta.quicklisp.org/archive/dynamic-classes/2013-01-28/dynamic-classes-20130128-git.tgz"
    sha256 "4a93d3a39dca61c87b29877fa9707b647fc08f117f80f2a741f649e4d04c4b44"
  end

  resource "esrap" do
    url "https://beta.quicklisp.org/archive/esrap/2016-12-04/esrap-20161204-git.tgz"
    sha256 "727f602aee2b8b275fb8bb0ba6ed604a50c1030037c266a42c81c37ff90e993b"
  end

  resource "flexi-streams" do
    url "https://beta.quicklisp.org/archive/flexi-streams/2015-07-09/flexi-streams-1.0.15.tgz"
    sha256 "f70c76e1724978100e26d9e0e0a0844939cde084b0d7f5623f1adbc8cb187d7e"
  end

  resource "garbage-pools" do
    url "https://beta.quicklisp.org/archive/garbage-pools/2013-07-20/garbage-pools-20130720-git.tgz"
    sha256 "05f014fd95526107af6d99a612b78292fbf3b8a6e9e2efcb04d6ab7e835ab6c5"
  end

  resource "ieee-floats" do
    url "https://beta.quicklisp.org/archive/ieee-floats/2016-03-18/ieee-floats-20160318-git.tgz"
    sha256 "a47baa0658b5ab8c202e85327a2dac5f639ae82471aed2b9ebee795fb0c1846f"
  end

  resource "ironclad" do
    url "https://beta.quicklisp.org/archive/ironclad/2014-11-06/ironclad_0.33.0.tgz"
    sha256 "e7f33e7ad79106de7a7f861013cde2812b83a22f6ab340fb37a6c4fad0efa0d1"
  end

  resource "iterate" do
    url "https://beta.quicklisp.org/archive/iterate/2016-08-25/iterate-20160825-darcs.tgz"
    sha256 "f55db27495b731c65f3d3dee8b453cd55924b22f1ef5e01df86dda6e9f097f4f"
  end

  resource "local-time" do
    url "https://beta.quicklisp.org/archive/local-time/2016-06-28/local-time-20160628-git.tgz"
    sha256 "eb57577bb046927b90eec9a2f5979e2f1e43f280d9c7eb90d9fb0a1d5f2d0a5d"
  end

  resource "lparallel" do
    url "https://beta.quicklisp.org/archive/lparallel/2016-08-25/lparallel-20160825-git.tgz"
    sha256 "213bc89e6bbabe07fc3bcb21be1021b31f6f2ab1b7a2abb358a01ab9bee69c73"
  end

  resource "md5" do
    url "https://beta.quicklisp.org/archive/md5/2015-08-04/md5-20150804-git.tgz"
    sha256 "856d522b4f60af0ead0435114c11100c0f5348e5e1db5fffe93a851be54dc7e9"
  end

  resource "metabang-bind" do
    url "https://beta.quicklisp.org/archive/metabang-bind/2014-11-06/metabang-bind-20141106-git.tgz"
    sha256 "84b0d7384a8f385140a11820e4f57cfd630c8e7ff48b44d357e9af9acd82be86"
  end

  resource "metatilities-base" do
    url "https://beta.quicklisp.org/archive/metatilities-base/2012-09-09/metatilities-base-20120909-git.tgz"
    sha256 "2a0f3f2b3d9724035e03c4bcb9fa587a2a638bd0fd64f20926d83efa09e8d4f8"
  end

  resource "nibbles" do
    url "https://beta.quicklisp.org/archive/nibbles/2016-12-04/nibbles-20161204-git.tgz"
    sha256 "04dac9ade7c38d2030968ee0ed11412eaaa778c52d5e246f66c6248177b48d19"
  end

  resource "parse-number" do
    url "https://beta.quicklisp.org/archive/parse-number/2014-08-26/parse-number-1.4.tgz"
    sha256 "90ae04cd1a43fe186d07e5f805faa6cc8a00d1134dd9d99b56e31fa2f5811279"
  end

  resource "postmodern" do
    url "https://beta.quicklisp.org/archive/postmodern/2016-12-04/postmodern-20161204-git.tgz"
    sha256 "a3e8b299f521632c33a57b63ef27cc2475f9b980170023b30e506ba36239dab3"
  end

  resource "puri" do
    url "https://beta.quicklisp.org/archive/puri/2015-09-23/puri-20150923-git.tgz"
    sha256 "0a0784c4d592733c1232fdee1074e9898a091359da142985a44b9528bff02a25"
  end

  resource "py-configparser" do
    url "https://beta.quicklisp.org/archive/py-configparser/2013-10-03/py-configparser-20131003-svn.tgz"
    sha256 "9d5365e66f5d788535d53ebf4c733e7d0d47c5b5e5f817c151503325e8c69a81"
  end

  resource "qmynd" do
    url "https://beta.quicklisp.org/archive/qmynd/2016-02-08/qmynd-20160208-git.tgz"
    sha256 "b8aa6cfb63a4e1baef4dfadca28a170bfa4a8b660b81a0740614e9d122a23575"
  end

  resource "quri" do
    url "https://beta.quicklisp.org/archive/quri/2016-12-04/quri-20161204-git.tgz"
    sha256 "7b29fe2c2746f2cf59eee703b2ff65b10e6ed2e10232f2c8456657d1e6402e92"
  end

  resource "salza2" do
    url "https://beta.quicklisp.org/archive/salza2/2013-07-20/salza2-2.0.9.tgz"
    sha256 "6aa36dc25fe2dfb411c03ad62edb39fcbf1d4ca8b45ba17a6ad20ebc9f9e10d4"
  end

  resource "split-sequence" do
    url "https://beta.quicklisp.org/archive/split-sequence/2015-08-04/split-sequence-1.2.tgz"
    sha256 "145c5c36e0b4edf77e2cf6df7f8c6b3aa9018211e269cafb97e9631bb7f3a58b"
  end

  resource "trivial-backtrace" do
    url "https://beta.quicklisp.org/archive/trivial-backtrace/2016-05-31/trivial-backtrace-20160531-git.tgz"
    sha256 "1df68d7d0f4a9611e5470cdacae58d594b26cc63b223e89fd85152b119559bed"
  end

  resource "trivial-features" do
    url "https://beta.quicklisp.org/archive/trivial-features/2016-12-04/trivial-features-20161204-git.tgz"
    sha256 "424681538abfa8c5af41fae0099c6e5cb9b05f823a094abba42fcac312f35f44"
  end

  resource "trivial-garbage" do
    url "https://beta.quicklisp.org/archive/trivial-garbage/2015-01-13/trivial-garbage-20150113-git.tgz"
    sha256 "08c0a03595843576835086dc5973cfb535f75f77de4b90e9c9b97c7eba97c1fb"
  end

  resource "trivial-gray-streams" do
    url "https://beta.quicklisp.org/archive/trivial-gray-streams/2014-08-26/trivial-gray-streams-20140826-git.tgz"
    sha256 "22757737e6b63a21f5e7f44980df8047f8c8294c290eeaaaf01bef1f31b80bda"
  end

  resource "trivial-utf-8" do
    url "https://beta.quicklisp.org/archive/trivial-utf-8/2011-10-01/trivial-utf-8-20111001-darcs.tgz"
    sha256 "8b17c345da11796663cfd04584445c62f09e789981a83ebefe7970a30b0aafd2"
  end

  resource "uiop" do
    url "https://beta.quicklisp.org/archive/uiop/2016-10-31/uiop-3.1.7.tgz"
    sha256 "7441b16e496c79379602901997f02f95651f476e479a744cb0293bf9190afd66"
  end

  resource "usocket" do
    url "https://beta.quicklisp.org/archive/usocket/2016-10-31/usocket-0.7.0.1.tgz"
    sha256 "c2454e8d8f65bf81aadf877d65d9b6364ed25f8560ad405063e2b4bfb872ecd6"
  end

  resource "uuid" do
    url "https://beta.quicklisp.org/archive/uuid/2013-08-13/uuid-20130813-git.tgz"
    sha256 "0e8657bdf7ad131641f6d878f953ebf74d3cda06b8be99dd8bb8cffbe34308de"
  end

  def install
    resources.each do |resource|
      resource.stage buildpath/"lib"/resource.name
    end

    ENV["CL_SOURCE_REGISTRY"] = "#{buildpath}/lib//:#{buildpath}//"
    ENV["ASDF_OUTPUT_TRANSLATIONS"] = "/:/"
    system "make", "pgloader-standalone", "BUILDAPP=buildapp"

    bin.install "build/bin/pgloader"
    man1.install "pgloader.1"
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
      begin
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
  end

  test do
    # Remove any Postgres environment variables that might prevent us from
    # isolating this disposable copy of Postgres.
    ENV.reject! { |key, _| key.start_with?("PG") }

    ENV["PGDATA"] = testpath/"data"
    ENV["PGHOST"] = testpath/"socket"
    ENV["PGDATABASE"] = "brew"

    (testpath/"test.load").write <<-EOS.undent
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
      assert_equal "6", shell_output("psql -Atc 'SELECT COUNT(*) FROM csv'").strip
    end
  end
end
