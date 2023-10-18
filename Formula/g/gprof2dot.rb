class Gprof2dot < Formula
  include Language::Python::Virtualenv

  desc "Convert the output from many profilers into a Graphviz dot graph"
  homepage "https://github.com/jrfonseca/gprof2dot"
  url "https://files.pythonhosted.org/packages/ab/0b/fc056b26a90c1836aa6c6e1332372dc13050d384f017e388131854ead8cf/gprof2dot-2022.7.29.tar.gz"
  sha256 "45b4d298bd36608fccf9511c3fd88a773f7a1abc04d6cd39445b11ba43133ec5"
  license "LGPL-3.0-or-later"
  head "https://github.com/jrfonseca/gprof2dot.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d81d5d7e30f6fe2443386056a21f0682f7d4173ee08114bca0dcfa16fbf00d56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b29fa6f9e3716b2a344d34f766e38dffe4bd8f7d03bef04eac1559164fe7b271"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bec1b03d7f2bf9352e6626c27d1d7921f79a83a1eecccc770f433a1ea6637aeb"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb0b813127a6b986e3f0a3ea3f568f47d2fdb92c8b0e2328076a0b8f3a86d495"
    sha256 cellar: :any_skip_relocation, ventura:        "287e26046fca0f033cbca837b6009c03d7bff89c77d8f6502910f73cc5d10f84"
    sha256 cellar: :any_skip_relocation, monterey:       "6cda88439199685a35d2950409f818eb1ac6f73184b87e5e036900a4444cdcb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66111cc1fda2c7add502c5927e0eb4c30927a9be529358baef86dc43be83e83a"
  end

  depends_on "graphviz"
  depends_on "python@3.12"

  on_linux do
    depends_on "libx11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"gprof.output").write <<~EOS
      Flat profile:

      Each sample counts as 0.01 seconds.
       no time accumulated

        %   cumulative   self              self     total
       time   seconds   seconds    calls  Ts/call  Ts/call  name
        0.00      0.00     0.00        2     0.00     0.00  manager
        0.00      0.00     0.00        2     0.00     0.00  worker1
        0.00      0.00     0.00        2     0.00     0.00  worker2
        0.00      0.00     0.00        1     0.00     0.00  project1
        0.00      0.00     0.00        1     0.00     0.00  project2

       %         the percentage of the total running time of the
      time       program used by this function.

      cumulative a running sum of the number of seconds accounted
       seconds   for by this function and those listed above it.

       self      the number of seconds accounted for by this
      seconds    function alone.  This is the major sort for this
                 listing.

      calls      the number of times this function was invoked, if
                 this function is profiled, else blank.

       self      the average number of milliseconds spent in this
      ms/call    function per call, if this function is profiled,
             else blank.

       total     the average number of milliseconds spent in this
      ms/call    function and its descendents per call, if this
             function is profiled, else blank.

      name       the name of the function.  This is the minor sort
                 for this listing. The index shows the location of
             the function in the gprof listing. If the index is
             in parenthesis it shows where it would appear in
             the gprof listing if it were to be printed.
      
                   Call graph (explanation follows)


      granularity: each sample hit covers 2 byte(s) no time propagated

      index % time    self  children    called     name
                      0.00    0.00       1/2           project1 [4]
                      0.00    0.00       1/2           project2 [5]
      [1]      0.0    0.00    0.00       2         manager [1]
                      0.00    0.00       2/2           worker1 [2]
                      0.00    0.00       2/2           worker2 [3]
      -----------------------------------------------
                      0.00    0.00       2/2           manager [1]
      [2]      0.0    0.00    0.00       2         worker1 [2]
      -----------------------------------------------
                      0.00    0.00       2/2           manager [1]
      [3]      0.0    0.00    0.00       2         worker2 [3]
      -----------------------------------------------
                      0.00    0.00       1/1           main [12]
      [4]      0.0    0.00    0.00       1         project1 [4]
                      0.00    0.00       1/2           manager [1]
      -----------------------------------------------
                      0.00    0.00       1/1           main [12]
      [5]      0.0    0.00    0.00       1         project2 [5]
                      0.00    0.00       1/2           manager [1]
      -----------------------------------------------

       This table describes the call tree of the program, and was sorted by
       the total amount of time spent in each function and its children.

       Each entry in this table consists of several lines.  The line with the
       index number at the left hand margin lists the current function.
       The lines above it list the functions that called this function,
       and the lines below it list the functions this one called.
       This line lists:
           index    A unique number given to each element of the table.
              Index numbers are sorted numerically.
              The index number is printed next to every function name so
              it is easier to look up where the function in the table.

           % time    This is the percentage of the `total' time that was spent
              in this function and its children.  Note that due to
              different viewpoints, functions excluded by options, etc,
              these numbers will NOT add up to 100%.

           self    This is the total amount of time spent in this function.

           children    This is the total amount of time propagated into this
              function by its children.

           called    This is the number of times the function was called.
              If the function called itself recursively, the number
              only includes non-recursive calls, and is followed by
              a `+' and the number of recursive calls.

           name    The name of the current function.  The index number is
              printed after it.  If the function is a member of a
              cycle, the cycle number is printed between the
              function's name and the index number.


       For the function's parents, the fields have the following meanings:

           self    This is the amount of time that was propagated directly
              from the function into this parent.

           children    This is the amount of time that was propagated from
              the function's children into this parent.

           called    This is the number of times this parent called the
              function `/' the total number of times the function
              was called.  Recursive calls to the function are not
              included in the number after the `/'.

           name    This is the name of the parent.  The parent's index
              number is printed after it.  If the parent is a
              member of a cycle, the cycle number is printed between
              the name and the index number.

       If the parents of the function cannot be determined, the word
       `<spontaneous>' is printed in the `name' field, and all the other
       fields are blank.

       For the function's children, the fields have the following meanings:

           self    This is the amount of time that was propagated directly
              from the child into the function.

           children    This is the amount of time that was propagated from the
              child's children to the function.

           called    This is the number of times the function called
              this child `/' the total number of times the child
              was called.  Recursive calls by the child are not
              listed in the number after the `/'.

           name    This is the name of the child.  The child's index
              number is printed after it.  If the child is a
              member of a cycle, the cycle number is printed
              between the name and the index number.

       If there are any cycles (circles) in the call graph, there is an
       entry for the cycle-as-a-whole.  This entry shows who called the
       cycle (as parents) and the members of the cycle (as children.)
       The `+' recursive calls entry shows the number of function calls that
       were internal to the cycle, and the calls entry for each member shows,
       for that member, how many times it was called from other members of
       the cycle.

      
      Index by function name

         [1] manager                 [5] project2                [3] worker2
         [4] project1                [2] worker1
    EOS
    system bin/"gprof2dot", testpath/"gprof.output", "-o", testpath/"call_graph.dot"
    assert_predicate testpath/"call_graph.dot", :exist?
  end
end
