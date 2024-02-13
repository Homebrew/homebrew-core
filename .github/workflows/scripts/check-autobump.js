const fs = require('fs')
const path = require('path');

module.exports = async ({github, context, core}, autobump_list) => {
  // Parse event
  const json = fs.readFileSync(process.env.GITHUB_EVENT_PATH, { encoding: "utf-8" })
  const event = JSON.parse(json)
  const pull = event.pull_request

  // Fetch PR files
  const files = await github.rest.pulls.listFiles({
      ...context.repo,
      pull_number: pull.number
  })

  const autobump_array = autobump_list.split(" ")

  for (const file of files.data) {
      if(autobump_array.includes(path.parse(file.filename).name)) {
        github.rest.issues.createComment({
          ...context.repo,
          issue_number: pull.number,
          body: `
Hi! You have used \`brew bump-formula-pr\` on a formula that is on the autobump list.
No need to manually bump it, BrewTestBot will automatically create an equivalent pull request for you!

We prefer that you spend time fixing broken pull requests instead of manually bumping formulae.`
        });
      }
  }
}
