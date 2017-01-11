require "English"

class Iwyu < Formula
  desc "analyze includes in C and C++ source files"
  homepage "https://include-what-you-use.org"
  url "https://include-what-you-use.org/downloads/include-what-you-use-0.7-x86_64-apple-darwin.tar.gz"
  version "0.7"
  sha256 "ba343d452b5d7b999c85387dff1750ca2d01af0c4e5a88a2144b395fa22d1575"

  def install
    # include-what-you-use looks for a lib directory one level up from its bin-
    # dir, but putting it directly in prefix results in it getting linked in
    # /usr/local/lib
    #
    # To solve this, we put iwyu in a custom dir and make bin links.
    iwyu_subdir_path = (prefix / "iwyu")
    iwyu_subdir_path.mkpath

    # just copy everything from the tarball's lib directory
    iwyu_subdir_path.install("lib")

    # selectively include certain binaries; give them better names
    iwyu_bindir = (iwyu_subdir_path / "bin")
    iwyu_bindir.mkpath

    iwyu_bindir.install("bin/fix_includes.py" => "fix_include")
    iwyu_bindir.install("bin/include-what-you-use")
    iwyu_bindir.install_symlink("include-what-you-use" => "iwyu")

    bin.install_symlink Dir["#{iwyu_bindir}/*"]
  end

  test do
    # write out a header and a C++ file relying on transitive dependencies
    (testpath / "demo.hpp").write <<-EOS.undent
    #include <stdio.h>
    #include <stdarg.h>
    #include <locale>
    EOS

    (testpath / "demo.cpp").write <<-EOS.undent
    #include "demo.hpp"

    int main(void)
    { printf("hello world"); }
    EOS

    # iwyu exits with a code equal to the number of suggested edits + 2
    fixes = shell_output "#{bin}/iwyu #{testpath}/demo.cpp 2>&1", 6
    assert_not_match(/file not found/, fixes)

    # pass the output to the fixer script and assert that it fixed two files
    results = pipe_output "#{bin}/fix_include", fixes
    assert_match(/IWYU edited 2 files/, results)

    # sigh. they use the status code to signal how many files were edited
    assert_equal 2, $CHILD_STATUS.exitstatus
  end
end
