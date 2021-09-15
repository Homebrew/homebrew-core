class Gprof2dot < Formula
  include Language::Python::Virtualenv

  desc "Convert the output from many profilers into a Graphviz dot graph"
  homepage "https://github.com/jrfonseca/gprof2dot"
  url "https://files.pythonhosted.org/packages/0f/80/11d3ec1703cc61606ddc68851747d1d1df3700d5e6c2b559af6dbeb398c5/gprof2dot-2021.2.21.tar.gz"
  sha256 "1223189383b53dcc8ecfd45787ac48c0ed7b4dbc16ee8b88695d053eea1acabf"
  license "LGPL-3.0-or-later"
  head "https://github.com/jrfonseca/gprof2dot.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff5a7c93c9ee8fda75fb559b15771a9833e232678ada2f36f5d378d86ec18e11"
    sha256 cellar: :any_skip_relocation, big_sur:       "7fde10f750d764840f63e58ffbeab678c565859810288d7bd3b6978d50bcd655"
    sha256 cellar: :any_skip_relocation, catalina:      "5c47790338ce21e3a7cbe32e9c366ddf1c451057d72bfe6f9c09ffb62d0b18c6"
    sha256 cellar: :any_skip_relocation, mojave:        "6a2ab69926fa5a54cb4f263f9f99398292bdb7aaaf252a34f6d6ba412c627599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "048208c256d6724196a87002d5058b0dd29c0df771d53c5c4c11a7b3a10e6a85"
  end

  depends_on "graphviz"
  depends_on "python@3.9"

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
