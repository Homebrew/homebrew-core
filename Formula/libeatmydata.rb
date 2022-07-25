class Libeatmydata < Formula
  desc "Because fsync() should be a no-op"
  homepage "https://www.flamingspork.com/projects/libeatmydata/"
  url "https://github.com/stewartsmith/libeatmydata/releases/download/v130/libeatmydata-130.tar.gz"
  sha256 "48731cd7e612ff73fd6339378fbbff38dd3bcf6c243593b0d9773ca0051541c0"
  license "GPL-3.0-or-later"
  head "https://github.com/stewartsmith/libeatmydata.git", branch: "master"

  depends_on "autoconf"         => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake"         => :build
  depends_on "libtool"          => :build

  depends_on "coreutils" => :test
  depends_on "grep"      => :test

  on_linux do
    depends_on "strace" => :test
  end

  def install
    system "autoreconf", "-vfi"
    system "./configure", *std_configure_args,
                          "--disable-option-checking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    # 0 - PASS: Successful test
    # 1 - FAIL: Result code missing
    # 2 - FAIL: eatmydata command missing
    # 3 - FAIL: sync command missing
    # 4 - FAIL: Unable to export LD_PRELOAD
    # 5 - FAIL: strace output missing
    # 6 - FAIL: Library malfunction
    # 7 - FAIL: Linux shared object missing
    # 8 - FAIL: Missing macOS dynamic library
    # 9 - FAIL: Unable to determine OS
    (testpath/"test.sh").write <<~EOS
      #!/usr/bin/env sh
      set -xeu 2> "/dev/null" 2>&1
      UNAME_S="$(
        exec 2> "/dev/null"
        uname -s |
          tr '[:upper:]' '[:lower:]'
      )" ||
        exit 9
      test -x "#{bin}/eatmydata" 2> "/dev/null" ||
        exit 2
      printf '%s\\n' "${UNAME_S:?}" |
        grep -q "darwin" &&
          {
            # More in-depth macOS testing requires root privileges
            command -v "sync" > "/dev/null" ||
              exit 3
            test -f "#{lib}/libeatmydata.dylib" 2> "/dev/null" ||
              exit 8
            rc=1
            "#{bin}/eatmydata" "--" 2>&1 |
              grep -q "^usage:.*eatmydata" &&
                {
                  "#{bin}/eatmydata" "sync"
                  rc="${?}"
                }
            exit ${rc:-1}
          } ||
          {
            LD_PRELOAD="#{lib}/libeatmydata.so"
            test -f "${LD_PRELOAD:?}" 2> "/dev/null" ||
              exit 7
            export LD_PRELOAD ||
              exit 4
            "#{Formula["strace"].opt_bin}/strace" -o "${$:?}-test.result.run" "sync"
            rc="${?}"
          }
      test "${rc:-1}" -ne 0 2> "/dev/null" &&
        exit 1
      test -f "${$:?}-test.result.run" 2> "/dev/null" ||
        exit 5
      set +e
      grep -E '(^[a-z]*sync|O_SYNC)' "${$:?}-test.result.run"
      rc="${?}"
      set -e
      rm -f "${$:?}-test.result.run" > "/dev/null" 2>&1 ||
        true
      test "${rc:-1}" -eq 1 2> "/dev/null" &&
        exit 0
      exit 6
    EOS
    chmod "+x", "#{testpath}/test.sh"
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"
    ENV.prepend_path "PATH", Formula["grep"].opt_libexec/"gnubin"
    system "#{testpath}/test.sh"
  end
end
