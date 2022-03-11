class Edbrowse < Formula
  desc "Command-line editor and web browser"
  homepage "https://www.edbrowse.org"
  url "https://github.com/CMB/edbrowse/archive/v3.8.2.tar.gz"
  sha256 "fed3d2a2ffa5f296ed5edeb5e08ac4cf0f4aec55c8c50945e3f45e300dd3706e"
  license all_of: ["GPL-2.0-only", "MIT"]
  head "https://github.com/CMB/edbrowse.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "pcre2"
  depends_on "readline"
  depends_on "tidy-html5"
  depends_on "unixodbc"
  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  resource "quickjs" do
    url "https://github.com/bellard/quickjs/archive/b5e62895c619d4ffc75c9d822c8d85f1ece77e5b.tar.gz"
    sha256 "640fb75b3ca11eec37f9df4bea0afa48a39027ca2dc60806b96d29aa03e504a6"
  end

  def install
    resource("quickjs").stage do
      # Add edbrowse-specific fields to quickjs
      quickjs_edbrowse_additions = <<~EOF.chomp
        // Tell edbrowse where the jobs field is within this structure.
        int JSRuntimeJobIndex = (int) offsetof(struct JSRuntime, job_list);
      EOF

      inreplace "quickjs.c",
        /(\nstruct JSRuntime +\{.*?\};\n)/m,
        "\\1\n#{quickjs_edbrowse_additions}\n"
      system "make"
      mkdir "#{buildpath}/quickjs"
      cp_r(".", "#{buildpath}/quickjs/")
    end

    # Patch the Makefile, so readline is used instead of libedit on Mac OS
    inreplace "src/makefile",
      "-lreadline",
      `pkg-config --libs readline`.chomp

    Dir.chdir "src" do
      # Some required libraries come from Homebrew
      lib_includes = `\
        pkg-config --cflags-only-I \
        libcurl libpcre2-8 odbc readline tidy \
      `.chomp
      with_env(
        "CFLAGS"          => lib_includes,
        "CXXFLAGS"        => lib_includes,
        "BUILD_EDBR_ODBC" => "on",
        "QUICKJS_DIR"     => "#{buildpath}/quickjs",
      ) do
        system "make"
      end
    end

    bin.install "src/edbrowse"
    doc.install "doc/usersguide.html"
    prefix.install "CHANGES"
    prefix.install "COPYING"
    prefix.install "README"
  end

  test do
    require "open3"
    (testpath/".ebrc").write ""
    (testpath/"js.html").write <<~EOF
      <!DOCTYPE html>
      <script>
      alert("Hello, world!");
      </script>
    EOF

    Open3.popen3("#{bin}/edbrowse", "-d0", "-b", testpath/"js.html") do |stdin, stdout, _|
      stdin.write "q\n"
      stdin.close

      assert_equal "Hello, world!", stdout.read.strip
    end
  end
end
