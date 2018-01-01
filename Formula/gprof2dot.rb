class Gprof2dot < Formula
  desc "Convert the output from many profilers into a Graphviz dot graph"
  homepage "https://github.com/jrfonseca/gprof2dot"
  url "https://files.pythonhosted.org/packages/9d/36/f977122502979f3dfb50704979c9ed70e6b620787942b089bf1af15f5aba/gprof2dot-2017.9.19.tar.gz"
  sha256 "cebc7aa2782fd813ead415ea1fae3409524343485eadc7fb60ef5bd1e810309e"

  head "https://github.com/jrfonseca/gprof2dot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b557363c9161ff1cd9de06cfb116eac29886c31f655c57d031ef2c6641fe876c" => :high_sierra
    sha256 "4cbf98d1320170ed6287d0b58bc7c810e29529de2ea5d5c4c2545443c6f5e3e2" => :sierra
    sha256 "2fe7080ddad320a9f73638f8d1ad072e97d6ba80825221414bae015019672852" => :el_capitan
  end

  depends_on "graphviz" => :recommended
  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
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
